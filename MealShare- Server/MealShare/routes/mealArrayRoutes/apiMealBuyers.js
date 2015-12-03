var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var mealsSchema = require('../../MongoModels/meals.js');

/*GET all buyers for a given meal*/
router.get('/:MId', function(req, res){
	mealsSchema.findOne(
		{"_id": req.params.MId},
		{"buyers":1},
		function(err, data){
		if(err){
			console.log('error getting meal buyers');
			console.log(err);
			res.send(err);
			return;
		}
		res.json(data);
	});
});

/*POST a new buyer to a meal*/
//edit this to ++/-- availableSpots - DONE!
router.post('/:MId', function(req,res){
	mealsSchema.findOne({"_id": req.params.MId}, function(err, data){
		if(err){
			console.log('error while adding new buyer to a meal - step 1');
			console.log(err);
			res.send(err);
			return;
		}
		if(data.availableSpots > 0){
			var newAvailableSpots = data.availableSpots-1;
			mealsSchema.update(
				{"_id": req.params.MId},
				{	
					$set: {
						availableSpots: newAvailableSpots,
					},
					$push: {
						"buyers": req.body.buyerID
					}
				},
				function(err, data){
					if(err){
						console.log('error while adding new buyer to a meal - step 2');
						console.log(err);
						res.send(err);
						return;
					}
					res.json({"added-a-new-buyer-to":req.params.MId});
				}
			);
		}
		else{
			res.json({"cannot-add-new-buyer": "no-spots-left"});
		}
	});
});

/*DELETE (remove) a buyer from a given meal*/
router.delete('/:MId/:PId', function(req, res){
	mealsSchema.findOne({"_id": req.params.MId}, function(err,data){
		if(err){
			console.log('error deleting buyer from a meal - step 1');
			console.log(err);
			res.send(err);
			return;
		}
		var newAvailableSpots = data.availableSpots+1;
		mealsSchema.update(
			{"_id": req.params.MId},
			{
				$set: {
					availableSpots: newAvailableSpots,
				},
				$pull: {
					"buyers": req.params.PId
				}
			},
			function(err,data){
				if(err){
					console.log('error deleting buyer from a meal - step 2');
					console.log(err);
					res.send(err);
					return;
				}
				res.json({"removed-buyer":req.params.PId});
			}
		);
	});

	/*mealsSchema.findByIdAndUpdate(
		{"_id":req.params.MId},
		{$pull: {"buyers": req.params.PId}},
		{},
		function(err, data){
			if(err){
				console.log('error removing a buyer from the meal: '+req.params.MId);
				console.log(err);
				res.send(err);
				return;
			}
			res.json({"removed-buyer":req.params.PId});
		}
	);*/
});

module.exports = router;