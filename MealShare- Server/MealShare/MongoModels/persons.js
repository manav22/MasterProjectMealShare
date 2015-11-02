var mongoose = require('mongoose');
var addressSchema = require('../MongoModels/addresses.js');

var ratingsSchema = new mongoose.Schema({
  comments: String,
  rating: {type: Number, min: 1, max: 5, required: true},
  ratedBy: {
    type: mongoose.Schema.ObjectId,
    ref: 'persons',
    required: true
  },
  ratedOn: {type: Date, required: true}
});

var personSchema = new mongoose.Schema({
  userName: {type: String, require: true},
  email: {type: String, require: true},
  password: {type: String, require: true},
  firstName: {type: String, require: true},
  lastName: {type: String, require: true},
  creditCardNumber: Number,
  dateOfBirth: Date,
  adresses: [addressSchema],
  contactNumbers: [Number],
  ratings: [ratingsSchema]
});

module.exports = mongoose.model('persons', personSchema);