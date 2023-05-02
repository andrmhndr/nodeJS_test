const db = require('../models');
const User = db.user;
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const key = require('../config/key');

exports.logout = async (req, res) => {
    try{
        const token = req.cookies.authorization.split(' ')[1];
        if(!token){
            return res.status(401).json({success: false, message: 'authorization fail'});
        }
        res.cookie('authorization', '');
        res.cookie('email', '');
        res.status(201).json({message: 'Logout berhasil'});
    } catch (err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
}

exports.get = async (req, res) => {
    try{
        const data = req.cookies;
        res.status(201).json({message: 'user data didapatkan', data: data});
    } catch (err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
}

exports.register = async (req, res) => {

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
}

exports.login = async (req, res) => {
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
        const token = jwt.sign({userId: user.id}, key.secretKey);

        res.cookie('authorization', 'Bearer ' + token);
        res.cookie('email', email);
        res.cookie('id', user.id);

        res.status(200).json({message: 'Login success', token, user});
    }catch(err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
}