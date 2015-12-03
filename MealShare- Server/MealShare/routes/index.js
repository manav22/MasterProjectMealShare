var express = require('express');
var router = express.Router();
var multer = require('multer');
var fs = require('fs');
var upload = multer(
	{
	    dest:'uploads/'
	}
);

/* GET home page. */
router.get('/', function(req, res) {
  res.render('pages/index', { title: 'Express' });
});

router.get('/upload', function(req, res){
	res.render('pages/upload');
});

router.post('/upload', /*upload.single('userPhoto'), */function(req,res,next){
	upload.single('image')(req, res, function(err){
		if (err) {
			console.log('in error');
			console.log(err)
			res.send(err);
			return;
		}
		console.log('title: '+req.body.title);
		console.log('body: '+JSON.stringify(req.body));
		console.log(req.file);
		res.json({'ok':'ok'});
	});
});

router.get('/getImage', function(req,res){
	//res.send(String(__dirname).slice(0,-6));// + '/views/pages/index.ejs');
	//res.sendFile(String(__dirname).slice(0,-7) + '/uploads/testImage');
	var img = fs.readFileSync(String(__dirname).slice(0,-7) + '/uploads/testImage');
    res.writeHead(200, {'Content-Type': 'image/gif' });
    //res.json({"image": img, "imageId": "anyRandomString"});
    res.end(img, 'binary');
});

module.exports = router;