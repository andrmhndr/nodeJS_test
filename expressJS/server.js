const express = require('express');
const mongoose = require('mongoose');
const db = require('./app/models');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const cors = require('cors');

const app = express();

//konfigurasi server
const PORT = process.env.PORT || 3000;

//middle ware untuk parsing JSON
app.use(cors());
app.use(express.json());
app.use(bodyParser.json());
app.use(cookieParser());

//konfigurasi database
db.mongoose.connect(db.url, {useNewUrlParser : true, useUnifiedTopology:true})
    .then(()=> console.log('Connect to database'))
    .catch((err) => {
        console.error(err);
        process.exit();
    });


//test
app.post('/',(req, res) => {

    User.create(req.body)
        .then(() => res.send({message: 'Data Berhasil disimpan'}))
        .catch(err => res.status(500).send({messageL: err.message}));
})

//memanggil route
require('./app/routes/user.routes')(app);
require('./app/routes/activity.routes')(app);

//menjalankan server
app.listen(PORT, () => console.log('Server started on port 3000'));

//export app untuk testing
module.exports = app;