const express = require('express');
const mongoose = require('mongoose');
const moment = require('moment');
const bcrypt = requrie('bcryptjs');
const jwt = require('jsonwebtoken');
const {google} = require('googleapis');

const app = express();

//konfigurasi server
const PORT = process.env.PORT || 3000;

//konfigurasi database
const DB_URI = process.env.DB_URI || 'mongodb://localhost:27017/test_nodejs';
mongoose.connect(DB_URI, {useNewUrlParser : true, useUnifiedTopology:true})
    .then(()=> console.log('Connect to database'))
    .catch((err) => console.error(err));

//middle ware untuk parsing JSON
app.use(express.json());

//endpoint API untuk register user
app.post('/register', async (req, res)=>{
    try{
        const {email, password} = req.body;
        
        //hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        //simpan user ke database
        const user = await User.create({email, password: hashedPassword});

        res.status(201).json({message: 'User created', data: user});
    } catch (err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
});

//endpoint API untuk login user
app.post('/login', async (req, res) => {
    try{
        const {email, password} = req.body;

        //cari user berdasar email
        const user = await User.findOne({email});

        if (!user){
            return res.status(401).json({message: 'Invalid credentials'});
        }

        //bandingkan password
        const isMatch = await bcrypt.compare(password, user.password);

        if(!isMatch){
            return res.status(401).json({message: 'Invalid credentials'});
        }
        
        //generate token
        const token = jwt.sign({userId: user._id}, process.env.JWT_SECRET, {expiresIn: '1h'});

        res.status(200).json({message: 'Login success', token});
    }catch(err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
});

//endpoint API untuk membuat kegiatan baru
app.post('/activities', authenticateToken, async (req, res)=>{
    try {
        const {name, date, startTime, endTime}= req.body;

        //buat kegiatan baru
        const activity = await Activity.create({name, date, startTime, endTime, userId: req.userId});

        res.status(201).json({message: 'Activity created', data: activity});
    } catch (err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
});

//endpoint API untuk membaca kegiata
app.get('/activities', authenticateToken, async (req, res) => {
    try {
        const activities = await Activity.find({userId:req.userId});
        
        //tambahkan status kegiatan
        const now = moment();
        activities.forEach((activity) => {
            const startTime = moment('${activity.date}T${activity.startTime');
            const endTime = moment('${activity.date}T${activity.endTime}');

            if (now.isBefore(startTime)){
                activity.status = 'Belum dilaksanakan';
            } else if (now.isBetween(startTime, endTime)){
                activity.status = 'Sedang dilaksanakan';
            } else {
                activity.status = 'Telah dilaksanakan';
            }
        });

        res.status(200).json({message: 'Activities retrieved', data: activities});
    } catch (err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
});

//endpoint API untuk mengupdate kegiatan
app.put('/activities/:id', authenticateToken, async (req, res) => {
    try {
        const {name, date, startTime, endTime} = req.body;
        
        //update kegiatan
        const activity = await Activity.findOneAndUpdate(
            { _id: req.params.id, userId: req.userId},
            {name, date, startTime, endTime},
            {new: true}
        );

        if (!activity){
            return res.status(404).json({message: 'Activity not found'});
        }

        res.status(200).json({message: 'Activity updated', data: activity});
    }catch(err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
});

//endpoint API untuk menghapus kegiatan
app.delete('/activities/:id', authenticateToken, async (res, req)=>{
    try{
        //hapus kegiatan
        const activity = await Activity.findOneAndDelete({_id:req.params.id, userId:req.userId});
        
        if (!activity){
            return res.status(404).json({message: 'Activity not found'});
        }

        res.status(200).json({message: 'Activity deleted', data: activity});
    }catch(err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
});

//endpoint API untuk menginvite seseorang dalam kegiatan
app.post('/activities/:id/invite', authenticateToken, async(req,res)=>{
    try{
        const {email} = req.body;

        //cari kegiatan 
        const activity = await Activity.findOne({_id: req.params.id, userId:req.userId});

        if(!activity){
            return res.status(404).json({message: 'Activity not found'});
        }

        //kirim undangan ke email
        //implementasi google calendar api
        const auth = new google.auth.JWT({
            email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL, 
            key: process.env.GOOGLE_PRIVATE_KEY,
            scopes: ['https://www.googleapis.com/auth/calendar'],
        });

        const calendar = google.calendar({version: 'v3', auth});

        const event = {
            summary: activity.name,
            start: {
                dateTime: '${activity.date}T${activity.startTime}:00',
                timeZone: 'Asia/Jakarta',
            },
            end: {
                dateTime: '${activity.date}T${activity.endTime}:00',
                timeZone: 'Asia/Jakarta',
            }, 
            attendees: [{email}],
        };

        //tambahkan event di google calendar
        const calendarResponse = await calendar.events.insert({
            calendarId: 'primary',
            resource: event,
            });

        //tambahkan invite ke dalam kegiatan
        activity.invitees.push({email, eventId: calendarResponse.data.id});
        await activity.save();

        res.status(200).json({message: 'Invitation sent', data: activity});
    }catch(err){
        console.error(err);
        res.status(500).json({message:'Internal server error'});
    }
})

//middleware untuk authenticating token 
function authenticateToken(req, res, next){
    const authHeader = req.headers['authorization'];
    const token = authHeader&&authHeader.split('')[1];

    if(!token){
        return res.status(401).json({message: 'Unauthorized'});
    }

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user)=>{
        if(err){
            return res.status(403).json({message: 'Forbidden'});
        }
        req.userId = user.id;
        next();
    });
}

//menjalankan server
app.listen(3000, () => console.log('Server started on port 3000'));

//export app untuk testing
module.exports = app;