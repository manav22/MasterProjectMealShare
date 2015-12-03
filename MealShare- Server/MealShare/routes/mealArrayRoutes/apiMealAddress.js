var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var mealsSchema = require('../../MongoModels/meals.js');

/*GET meal address*/
router.get('/:MId', function(req, res){
	mealsSchema.findOne(
		{"_id": req.params.MId},
		{"mealAddress":1},
		function(err, data){
		if(err){
			console.log('error getting meal mealAddress');
			console.log(err);
			res.send(err);
			return;
		}
		res.json(data);
	});
});

/*POST the mealAddress*/
/*THIS ROUTE IS NOT WORKING!! - FIX THIS*/
router.post('/:MId', function(req,res){
	mealsSchema.findOne({"_id": req.params.MId}, function(err, data){
		if(err){
			console.log('error while adding the mealAddress - step 1');
			console.log(err);
			res.send(err);
			return;
		}

		//add address only if address is not already present
		if(data.mealAddress.length == 0){
			//build the newAddress object
			var newMealAddress = {
				addressStreet1: req.body.addressStreet1,
				addressCity: req.body.addressCity,
				addressState: req.body.addressState,
				addressCountry: req.body.addressCountry,
				addressZipcode: parseInt(req.body.addressZipcode)
			}
			if(req.body.addressStreet2){
				newMealAddress.addressStreet2 = req.body.addressStreet2;
			}
			if(req.body.addressUnitNumber){
				newMealAddress.addressUnitNumber = req.body.addressUnitNumber;
			}


			mealsSchema.update(
				{"_id": req.params.MId},
				{$push: {"mealAddress": newMealAddress}},
				function(err, data){
					if(err){
						console.log('error while adding the mealAddress - step 2');
						console.log(err);
						res.send(err);
						return;
					}
					res.json({"added-the-mealAddress-to":req.params.MId});
				}
			);
		}
		else{
			res.json({"mealAddress-already-present": "cannot-add-more-mealAddresses"});
		}
	});
});


/*DELETE (remove) the mealAddress*/
router.delete('/:MId/:addressID', function(req, res){
	mealsSchema.findByIdAndUpdate(
		{"_id":req.params.MId},
		{$pull: {"mealAddress": {"_id": req.params.addressID}}},
		{},
		function(err, data){
			if(err){
				console.log('error removing the mealAddress for meal: '+req.params.MId);
				console.log(err);
				res.send(err);
				return;
			}
			res.json({"removed-mealAddress-for":req.params.MId});
		}
	);
});


module.exports = router;