var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var personSchema = require('../../MongoModels/persons.js');

/*GET all contactNumbers for a given person*/
router.get('/:PId', function(req, res){
	personSchema.findOne(
		{"_id": req.params.PId},
		{"contactNumbers":1},
		function(err, data){
		if(err){
			console.log("error getting person's contactNumbers");
			console.log(err);
			res.send(err);
			return;
		}
		res.json(data);
	});
});

/*POST a new contactNumber to a person*/
router.post('/:PId', function(req,res){
	personSchema.findByIdAndUpdate(
		{"_id":req.params.PId},
		{$push: {"contactNumbers": parseInt(req.body.contactNumber)}},
		{},
		function(err, data){
			if(err){
				console.log('error adding a new contactNumber to the person: '+req.params.PId);
				console.log(err);
				res.send(err);
				return;
			}
			res.json({"added-a-new-contactNumber-to":req.params.PId});
		}
	);
});

/*DELETE (remove) a contactNumber from a given person*/
//fix this... cast exception!
router.delete('/:PId/:contactNumber', function(req, res){
	personSchema.findByIdAndUpdate(
		{"_id":req.params.PId},
		{$pull: {"contactNumbers": req.params.contactNumber}},
		{},
		function(err, data){
			if(err){
				console.log('error removing a contactNumber from the person: '+req.params.PId);
				console.log(err);
				res.send(err);
				return;
			}
			res.json({"removed-contactNumber":req.params.contactNumber});
		}
	);
});

module.exports = router;