
module.exports = mongoose => {
    const schema = mongoose.Schema(
        {
            name: {
                type: String,
                required: true
              },
            startTime: {
                type: Date,
                required: true
            },
            endTime: {
                type: Date,
                required: true
            },
            email: {
                type: String,
                required: true
            },
        }, {
            timestamps: true,
        }
    );

    return mongoose.model('activity', schema);
}