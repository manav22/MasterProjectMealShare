var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var mealsSchema = require('../../MongoModels/meals.js');

/*GET all foodItems for a given meal*/
router.get('/:MId', function(req, res){
	mealsSchema.findOne(
		{"_id": req.params.MId},
		{"foodItems":1},
		function(err, data){
		if(err){
			console.log('error getting meal foodItems');
			console.log(err);
			res.send(err);
			return;
		}
		res.json(data);
	});
});

/*POST a new foodItem to a meal*/
router.post('/:MId', function(req,res){
	mealsSchema.findByIdAndUpdate(
		req.params.MId,
		{
			$push: {"foodItems":
				{
					name: req.body.name,
					description: req.body.description,
					ingredients: []
				}
			}
		},
		function(err,data){
			if(err){
				console.log('error adding a meal foodItem');
				console.log(err);
				res.send(err);
				return;
			}
			res.json({"added-foodItem-to": req.params.MId});
		}
	);
});

/*PUT (edit) a foodItem from a meal - except 'ingredients'*/
/*nested array item 'ingredients' has a different route*/
router.put('/:Mid/:foodItemId', function(req, res){
	mealsSchema.findOne(
		{"foodItems._id": req.params.foodItemId},
		{"foodItems":1},
		{},
		function(err,data){
			if(err){
				console.log('error PUTting foodItem in a meal - step 1');
				console.log(err);
				res.send(err);
				return;
			}

			//check if data has 'foodItems' property
			if(data.foodItems){
				if(req.body.name){
					data.foodItems[0].name = req.body.name;
				}
				if(req.body.description){
					data.foodItems[0].description = req.body.description;
				}

				data.save(function(err, data){
					if(err){
						console.log('error PUTting a foodItem in a Meal - step 2');
						console.log(err);
						res.send(err);
						return;
					}
					res.json({"modified-foodItem-inMeal": req.params.Mid});
				});
			}
			else
				res.json({"requested-foodItem": "notFound"});
		}
	);
});

/*DELETE (remove) a foodItem from a given meal*/
router.delete('/:MId/:foodItemId', function(req, res){
	mealsSchema.findByIdAndUpdate(
		{"_id":req.params.MId},
		{$pull: {"foodItems": {"_id": req.params.foodItemId}}},
		{},
		function(err, data){
			if(err){
				console.log('error removing a foodItem from the meal: '+req.params.MId);
				console.log(err);
				res.send(err);
				return;
			}
			res.json({"removed-foodItem":req.params.foodItemId});
		}
	);
});

module.exports = router;