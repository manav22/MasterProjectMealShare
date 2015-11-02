var mongoose = require('mongoose');
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
	title: {type: String, required: true},
	description: String,
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

module.exports = mongoose.model('meals', mealSchema);