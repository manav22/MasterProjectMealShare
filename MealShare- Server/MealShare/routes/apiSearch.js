var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var elasticsearch = require('elasticsearch');
//var mongoosastic = require('mongoosastic');
var personSchema = require('../MongoModels/persons.js');
var mealSchema = require('../MongoModels/meals.js');

var client = new elasticsearch.Client({
	host: 'localhost:9200'
});

/*GET all persons*/
router.get('/:searchString', function(req, res){
	client.search({
		q: req.params.searchString
	})
	.then(
		function(resp){
			res.send(resp.hits.hits);
			return;
		},
		function(err){
			res.send(err);
			return;
		}
	);
});

module.exports = router;