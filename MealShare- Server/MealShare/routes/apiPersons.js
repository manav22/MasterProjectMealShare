var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var personSchema = require('../MongoModels/persons.js');

/*GET all persons*/
router.get('/', function(req, res){
	personSchema.find(function(err, data){
		if(err){
			console.log('error getting all persons: '+err);
			console.log(err);
			res.send(err);
			return;
		}
		res.json(data);
	});
});

/*GET a single OR few persons*/
router.get('/:param', function(req, res){
	var array = req.params.param.split(",");
	//for getting a single meal
	if(array.length==1){
		personSchema.findOne({"_id": array[0]}, function(err, data){
			if(err){
				console.log('error GETting a single person');
				console.log(err);
				res.send(err);
				return;
			}
			res.json(data);
		});
	}
	//for getting multiple (could be all) persons
	else{
		personSchema.find(
			{"_id": {$in: array}},
			function(err, data){
				if(err){
					console.log('error GETting multiple persons');
					console.log(err);
					res.send(err);
					return;
				}
				res.json(data);
			}
		);
	}
});

/*POST a single person*/
router.post('/', function(req,res){
	if( !req.body.userName ||
		!req.body.password ||
		!req.body.email ||
		!req.body.firstName ||
		!req.body.lastName){
			res.json({"insufficient": "data"});
		}
	var person = {
		userName: req.body.userName,
		email: req.body.email,
		password: req.body.password,
		firstName: req.body.firstName,
		lastName: req.body.lastName,
		creditCardNumber: 0123456789,
		dateOfBirth: new Date("1990-10-10T00:00:00Z"),
		adresses: [],
		contactNumbers: [],
		ratings: []
	};
	var item = new personSchema(person);
	item.save(function(err, status){
		if (err){
			console.log('error adding a new person to DB');
			console.log(err);
			res.send(err);
			return;
		}
		console.log("added a new person to DB");
		res.json({"added-new-person": person.firstName});
	});
});

/*PUT (edit) a person - except contact, addresse & ratings*/
/*nested items (nested arrays) have a different route*/
/*use those routes to edit arrays*/
router.put('/:Pid', function(req, res){
	personSchema.findById(req.params.Pid, function(err, person){
			if(err){
				console.log('error PUTting new Person');
				console.log(err);
				res.send(err);
				return;
			}

			if(req.body.userName){
				person.userName = req.body.userName;
			}
			if(req.body.email){
				person.email = req.body.email;
			}
			if(req.body.password){
				person.password = req.body.password;
			}
			if(req.body.firstName){
				person.firstName = req.body.firstName;
			}
			if(req.body.lastName){
				person.lastName = req.body.lastName;
			}
			if(req.body.creditCardNumber){
				person.creditCardNumber = req.body.creditCardNumber;
			}
			if(req.body.dateOfBirth){
				person.dateOfBirth = new Date(req.body.dateOfBirth);
			}

			person.save(function(err, data){
				if(err){
					console.log('error PUTting new Person');
					console.log(err);
					res.send(err);
					return;
				}
				res.json({"modified": req.params.Pid});
			});
		}
	);
});

/*DELETE a person*/
router.delete('/:PId', function(req, res){
	personSchema.remove({"_id": req.params.PId}, function(err,data){
		if(err){
			console.log("error removing a person");
			console.log(err);
			res.send(err);
			return;
		}
		res.json({"removed": req.params.PId});
	});
});

module.exports = router;