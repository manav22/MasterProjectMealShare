var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var mealsSchema = require('../../MongoModels/meals.js');

/*GET all cuisines for a given meal*/
router.get('/:MId', function(req, res){
	mealsSchema.findOne(
		{"_id": req.params.MId},
		{"cuisines":1},
		function(err, data){
		if(err){
			console.log('error getting meal cuisines');
			console.log(err);
			res.send(err);
			return;
		}
		res.json(data);
	});
});

/*POST a new cuisine to a meal*/
router.post('/:MId', function(req,res){
	var cuisine = {
		name: req.body.name
	};
	if(req.body.description){
		cuisine.description = req.body.description;
	}
	mealsSchema.findByIdAndUpdate(
		{"_id":req.params.MId},
		{$push: {"cuisines": cuisine}},
		{},
		function(err, data){
			if(err){
				console.log('error adding a new cuisine to the meal: '+req.params.MId);
				console.log(err);
				res.send(err);
				return;
			}
			res.json({"added-a-new-cuisine-to":req.params.MId});
		}
	);
});

/*DELETE (remove) a cuisine from a given meal*/
router.delete('/:MId/:cuisineName', function(req, res){
	mealsSchema.findByIdAndUpdate(
		{"_id":req.params.MId},
		{$pull: {"cuisines": {name: req.params.cuisineName}}},
		{},
		function(err, data){
			if(err){
				console.log('error removing a cuisine from the meal: '+req.params.MId);
				console.log(err);
				res.send(err);
				return;
			}
			res.json({"removed-cuisine":req.params.cuisineName});
		}
	);
});

module.exports = router;