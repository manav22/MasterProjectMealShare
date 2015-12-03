var mongoose = require('mongoose');
var mongoosastic = require('mongoosastic');
var addressSchema = require('../MongoModels/addresses.js');

var foodItemSchema = new mongoose.Schema({
	name: {type: String, required: true},
	description: {type: String, required: true},
	ingredients: [{
		name: {type: String, required: true},
		description: String
	}]
});

var mealSchema = mongoose.Schema({
	title: {type: String, required: true, es_indexed:true},
	description: {type: String, es_indexed:true},
	mealAddress: [addressSchema],
	seller: {
		type: mongoose.Schema.ObjectId,
	    ref: 'persons',
	    required: true
	},
	foodItems: [foodItemSchema],
	buyers: [{
		type: mongoose.Schema.ObjectId,
	    ref: 'persons'
	}],
	availableSpots: {type: Number, required: true},
	cuisines: [{
		name: {type: String, required: true},
		description: String
	}], 
	startDateTime: {type: Date, required: true},
	endDateTime: {type: Date, required: true}
});


mealSchema.plugin(mongoosastic, {
  host: 'localhost',
  port: 9200,
  protocol: 'http',
  index: 'mealshare',
  type: 'meals'
});


var meals = mongoose.model('meals', mealSchema);

meals.createMapping(function(err,mapping){
	if(err){
		console.log(err);
		return;
  	}
  	console.log(mapping);
});

//only ADDS new items from MongoDB, DOES NOT delete extra ones from es
/*var stream = meals.synchronize();
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

module.exports = meals;