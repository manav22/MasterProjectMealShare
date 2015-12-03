var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');

var routes = require('./routes/index');
var apiMeals = require('./routes/apiMeals');
var apiMealBuyers = require('./routes/mealArrayRoutes/apiMealBuyers');
var apiPersons = require('./routes/apiPersons');
var apiPersonContactNumbers = require('./routes/personArrayRoutes/apiPersonContactNumbers');
var apiMealCuisines = require('./routes/mealArrayRoutes/apiMealCuisines');
var apiMealFoodItems = require('./routes/mealArrayRoutes/apiMealFoodItems');
var apiMealAddress = require('./routes/mealArrayRoutes/apiMealAddress');
var apiSearch = require('./routes/apiSearch');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Fix for Any Origin HTTP Calls
var allowCrossDomain = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type,Accept,x-access-token');
    if(req.method == 'OPTIONS'){
      res.status(200).end();
    } else {
    next();
    }
}

//MongoDB connection
mongoose.connect('mongodb://localhost/MealShare', function(err) {
    if(err) {
        console.log('MongoDB connection error', err);
    } else {
        console.log('connected to MongoDB');
    }
});


// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'bower_components')));
app.use(express.static(path.join(__dirname, 'uploads')));

// Fix for Any Origin HTTP Calls
app.use(allowCrossDomain);

//default routes
app.use('/', routes);
//meal routes
app.use('/api/meals', apiMeals);
app.use('/api/meals/buyers', apiMealBuyers);
app.use('/api/meals/cuisines', apiMealCuisines);
app.use('/api/meals/foodItems', apiMealFoodItems);
app.use('/api/meals/address', apiMealAddress);
//person routes
app.use('/api/persons', apiPersons);
app.use('/api/persons/contactNumbers', apiPersonContactNumbers);
//search route
app.use('/api/search', apiSearch);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('pages/error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('pages/error', {
        message: err.message,
        error: {}
    });
});


module.exports = app;
