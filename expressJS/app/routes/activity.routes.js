const key = require('../config/key');
const jwt = require('jsonwebtoken');

module.exports = app => {
    const activity = require('../controllers/activity.controller');
    const r = require('express').Router();

    r.post('/create', activity.create);
    r.get('/', activity.getAll);
    r.put('/update/:id',  activity.update);
    r.delete('/delete/:id',  activity.delete);
    r.post('/invite/:id',  activity.invite);

    function authenticateToken(req, res, next){
        console.log(req.cookies.authorization);
        const authHeader = req.cookies.authorization;
        const token = authHeader&&authHeader.split(' ')[1];
    
        if(!token){
            return res.status(401).json({message: 'Unauthorized'});
        }
    
        jwt.verify(token, key.secretKey, (err, user)=>{
            if(err){
                return res.status(403).json({message: err});
            }
            req.userId = user.id;
            next();
        });
    }

    app.use('/activities',r);
}