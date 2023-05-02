module.exports = app => {
    const user = require('../controllers/user.controller');
    const r = require('express').Router();

    r.post('/register', user.register);
    r.post('/login', user.login);
    r.get('/get', user.get);
    r.get('/logout', user.logout);

    app.use('/user', r);
}