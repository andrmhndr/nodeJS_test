module.exports = mongoose => {
    const schema = mongoose.Schema(
        {
            email: {
                type: String, 
                required: true
            },
            password: {
                type: String, 
                required: true
            },
        }, {
            timestamps: true,
        }
    );

    return mongoose.model('user', schema);
}