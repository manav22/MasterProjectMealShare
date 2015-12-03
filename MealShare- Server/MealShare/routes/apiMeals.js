var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var elasticsearch = require('elasticsearch');
var mealsSchema = require('../MongoModels/meals.js');

var client = new elasticsearch.Client({
	host: 'localhost:9200'
});

/*GET all meals*/
router.get('/', function(req, res){
	mealsSchema.find(function(err, data){
		if(err){
			console.log('error getting meals: '+err);
			console.log(err);
			res.send(err);
			return;
		}
		res.json(data);
	});
});

/*GET a single OR few meals*/
router.get('/:param', function(req, res){
	var array = req.params.param.split(",");
	//for getting a single meal
	if(array.length==1){
		mealsSchema.findOne({"_id": array[0]}, function(err, data){
			if(err){
				console.log('error GETting a single meal');
				console.log(err);
				res.send(err);
				return;
			}
			res.json(data);
		});
	}
	//for getting multiple (could be all) meals
	else{
		mealsSchema.find(
			{"_id": {$in: array}},
			function(err, data){
				if(err){
					console.log('error GETting multiple meals');
					console.log(err);
					res.send(err);
					return;
				}
				res.json(data);
			}
		);
	}
});

/*POST a single meal*/
router.post('/', function(req,res){
	console.log(req.body);
	console.log(req.params);
	var meal = {
		title: req.body.title,
		seller: req.body.seller,
		availableSpots: req.body.availableSpots,
		startDateTime: new Date(req.body.startDateTime),
		endDateTime: new Date(req.body.endDateTime),
		cuisines: [],
		buyers: [],
		mealAddress: [],
		foodItems: []
	};
	var item = new mealsSchema(meal);
	item.save(function(err, status){
		if (err){
			console.log('error adding a new meal');
			console.log(err);
			res.send(err);
			return;
		}
		console.log("added a new meal");
		res.json({"added-new-meal": meal.title});
	});
});

/*PUT (edit) a meal - except mealAddress, buyers & cuisines*/
/*nested items (nested arrays) have a different route*/
/*use those routes to edit arrays*/
router.put('/:Mid', function(req, res){
	mealsSchema.findById(req.params.Mid, function(err, meal){
			if(err){
				console.log('error PUTting new meal');
				console.log(err);
				res.send(err);
				return;
			}

			if(req.body.title){
				meal.title = req.body.title;
			}
			if(req.body.seller){
				meal.seller = req.body.seller;
			}
			if(req.body.availableSpots){
				meal.availableSpots = req.body.availableSpots;
			}
			if(req.body.startDateTime){
				meal.startDateTime = new Date(req.body.startDateTime);
			}
			if(req.body.endDateTime){
				meal.endDateTime = new Date(req.body.endDateTime);
			}

			meal.save(function(err, data){
				if(err){
					console.log('error PUTting new Meal');
					console.log(err);
					res.send(err);
					return;
				}
				res.json({"modified": req.params.Mid});
			});
		}
	);
});


/*DELETE a meal*/
router.delete('/:MId', function(req, res){
	mealsSchema.remove({"_id": req.params.MId}, function(err, data){
		if(err){
			console.log('error deleting a meal');
			console.log(err);
			res.send(err);
			return;
		}

		client.delete(
			{
				index: 'mealshare',
				type: 'meals',
				id: String(req.params.MId)
			},
			function(err, res){
				if(err){
					console.log('es delete error:\n'+err);
					return;
				}
				console.log(res);
			}
		);

		res.json({"removed-meal":req.params.MId});
	});
});

module.exports = router;