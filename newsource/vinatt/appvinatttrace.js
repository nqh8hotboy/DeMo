var http =require('https');
var express = require('express');
var i18n = require('./module/i18n');
var fs = require('fs-extra');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var debug = require('debug')('vina:server');
//var indexRouter = require('./routes/index');
require('events').EventEmitter.defaultMaxListeners = 0
var core = require('./module/core');
var connect=require('./module/connect');
var session = require('express-session');
var app = express();
var http = require('https');
var bodyParser = require('body-parser');

app.use(bodyParser.json({limit: '100mb'}));
app.use(bodyParser.urlencoded({limit: '100mb', extended: true}));

app.use(session({
    secret: '2C44-4D44-WppQ38S',
    resave: false,
    saveUninitialized: true
}));
app.use(function (req, res, next) {
    res.header('Access-Control-Allow-Origin', req.headers.origin);
    res.header('Access-Control-Allow-Credentials',true);
    res.header('Access-Control-Allow-Method','GET,POST,PUT,DELETE');
    res.header('Access-Control-Allow-Headers', 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Accept');
    next();
});

/**
 * Get port from environment and store in Express.
 */

var port = normalizePort(process.env.PORT || '8080');
app.set('port', port);

/**
 * Create HTTP server.
 */



/**
 * Normalize a port into a number, string, or false.
 */

function normalizePort(val) {
  var port = parseInt(val, 10);

  if (isNaN(port)) {
    // named pipe
    return val;
  }

  if (port >= 0) {
    // port number
    return port;
  }

  return false;
}

/**
 * Event listener for HTTP server "error" event.
 */

function onError(error) {
  if (error.syscall !== 'listen') {
    throw error;
  }

  var bind = typeof port === 'string'
    ? 'Pipe ' + port
    : 'Port ' + port;

  // handle specific listen errors with friendly messages
  switch (error.code) {
    case 'EACCES':
      console.error(bind + ' requires elevated privileges');
      process.exit(1);
      break;
    case 'EADDRINUSE':
      console.error(bind + ' is already in use');
      process.exit(1);
      break;
    default:
      throw error;
  }
}

/**
 * Event listener for HTTP server "listening" event.
 */

function onListening() {
  var addr = server.address();
  var bind = typeof addr === 'string'
    ? 'pipe ' + addr
    : 'port ' + addr.port;
  console.log('Listening on ' + bind);
}
app.use(bodyParser.json({limit: '100mb'}));
app.use(bodyParser.urlencoded({limit: '100mb', extended: true}));
app.use(cookieParser());
//app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname,'/public')));

// view engine setup
app.set('views', path.join(__dirname, '/views'));
app.set('view engine', 'ejs');
app.engine('html', require('ejs').renderFile);
app.use(i18n);
app.use(logger('dev'));
//app.use(express.json());
//app.use(express.urlencoded({ extended: false }));

//app.use('/public', express.static('public'));
//app.use('/', indexRouter);
app.use('/load_cookie',require('./module/load_cookie'));
app.use('/news',require('./module/news'));
app.use('/upload',require('./module/upload'));
app.use('/users',require('./module/users'));
app.use('/lands',require('./module/lands'));
//module.exports = app;
app.use('/dangkysp',require('./module/dangkysp'));
app.use('/dulich',require('./module/dulich'));
app.use('/loaisp',require('./module/loaisp'));
app.use('/nhacungcap',require('./module/nhacungcap'));
app.use('/nhaphanphoi',require('./module/nhaphanphoi'));
app.use('/nhasoche',require('./module/nhasoche'));
app.use('/sanpham',require('./module/sanpham'));
app.use('/ads',require('./module/ads'));
app.use('/thongke',require('./module/thongke'));
app.use('/gioithieu',require('./module/gioithieu'));
app.use('/activity',require('./module/activity'));
app.use('/nhavc',require('./module/nhavc'));