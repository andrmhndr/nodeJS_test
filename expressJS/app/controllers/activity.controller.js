const db = require('../models');
const key = require('../config/key');
const Activity = db.activity;
const jwt = require('jsonwebtoken');
const moment = require('moment');
const nodemailer = require('nodemailer');

exports.create =  async (req, res) => {
    try {

        const {name, startTime, endTime, email} = req.body;

        //buat kegiatan baru
        const activity = await Activity.create({name, startTime, endTime, email});

        res.status(201).json({message: 'Activity created', data: activity});
    } catch (err){
        console.error(req);
        res.status(500).json({message: 'Internal server error'});
    }
}

exports.invite = async(req,res)=>{
    try{
        const {email} = req.body;

        //cari kegiatan 
        const activity = await Activity.findOne({_id: req.params.id});

        if(!activity){
            return res.status(404).json({message: 'Activity not found'});
        }

        res.status(200).json({message: 'Invitation sent', data: activity});
    }catch(err){
        console.error(err);
        res.status(500).json({message:'Internal server error'});
    }
}

exports.delete = async (req, res) => {
    try{
        //hapus kegiatan
        const activity = await Activity.findOneAndDelete({_id:req.params.id});
        
        if (!activity){
            return res.status(404).json({message: 'Activity not found'});
        }

        res.status(200).json({message: 'Activity deleted', data: activity});
    }catch(err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
}

exports.getAll = async (req, res) => {
    try {
        const activities = await Activity.find({});
        
        //tambahkan status kegiatan
        const now = moment();
        const activitiesWithStatus = activities.map((activity) => {
            const startTime = moment(activity.startTime);
            const endTime = moment(activity.endTime);
            let status = '';
          
            if (now.isBefore(startTime)) {
              status = 'Belum dilaksanakan';
            } else if (now.isBetween(startTime, endTime)) {
              status = 'Sedang dilaksanakan';
            } else {
              status = 'Telah dilaksanakan';
            }
          
            // Menambahkan data status ke objek kegiatan
            return { 
              id: activity.id, 
              name: activity.name, 
              startTime: activity.startTime, 
              endTime: activity.endTime, 
              email: activity.email,
              status: status 
            };
          });

        res.status(200).json({message: 'Activities retrieved', data: activitiesWithStatus});
    } catch (err){
        console.error(err);
        res.status(500).json({message: 'Internal server error'});
    }
}

exports.update = async (req, res) => {
    try {
        const {name, startTime, endTime, userId} = req.body;
        
        //update kegiatan
        const activity = await Activity.findOneAndUpdate(
            { _id: req.params.id},
            {name, startTime, endTime, userId},
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
}