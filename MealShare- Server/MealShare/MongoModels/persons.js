var mongoose = require('mongoose');
var mongoosastic = require('mongoosastic');
var addressSchema = require('../MongoModels/addresses.js');

var ratingsSchema = new mongoose.Schema({
  review: String,
  rating: {type: Number, min: 1, max: 5, required: true},
  ratedBy: {
    type: mongoose.Schema.ObjectId,
    ref: 'persons',
    required: true
  },
  ratedOn: {type: Date, required: true}
});

var personSchema = new mongoose.Schema({
  userName: {type: String, require: true, es_indexed:true},
  email: {type: String, require: true},
  password: {type: String, require: true},
  firstName: {type: String, require: true, es_indexed:true},
  lastName: {type: String, require: true, es_indexed:true},
  creditCardNumber: Number,
  dateOfBirth: Date,
  adresses: [addressSchema],
  contactNumbers: [Number],
  ratings: [ratingsSchema],
});


personSchema.plugin(mongoosastic, {
  host: 'localhost',
  port: 9200,
  protocol: 'http',
  index: 'mealshare',
  type: 'persons'
});


var persons = mongoose.model('persons', personSchema);

persons.createMapping(function(err,mapping){
  if(err){
    console.log(err);
    return;
  }
  console.log(mapping);
});


//only ADDS new items from MongoDB, DOES NOT delete extra ones from es
/*var stream = persons.synchronize();
var count=0;
stream.on('data', function(err, doc){
  count++;
});
stream.on('close', function(){
  console.log('indexed ' + count + ' documents!');
});
stream.on('error', function(err){
  console.log(err);
});*/


module.exports = persons;