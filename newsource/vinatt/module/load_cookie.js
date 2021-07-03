express = require('express');
var router = express.Router();
var core=require('./core');
var connect=require('./connect');
//var connect2=require('./connect2');
var SHA256 = require("crypto-js/sha256");
var i18n = require('i18n');
//get tất cả các label từ cookie
router.get('/index', function(req, res) {
	 i18n.init(req, res);
	   var datareq = req.body;
	 res.cookie('lang', datareq.lang, { maxAge: 900000 });
	
 var list_label={};
  list_label.home=res.__('Home');
  list_label.Introduce=res.__('Introduce');
  list_label.Product=res.__('Product');
  list_label.Customer_support=res.__('Customer_support');
  list_label.News=res.__('News');
  list_label.Gallery=res.__('Gallery');
  list_label.Contact=res.__('Contact');
  list_label.Login=res.__('Login');
  list_label.CheckOut=res.__('CheckOut');
  list_label.Namecompany=res.__('Namecompany');
  list_label.Partner=res.__('Partner');
   list_label.LoganVINATT=res.__('LoganVINATT');
    list_label.LoganVINATT1=res.__('LoganVINATT1');
	 list_label.LoganVINATT2=res.__('LoganVINATT2');
	 list_label.VideoTree=res.__('VideoTree');
	 list_label.SpecicalProduct=res.__('SpecicalProduct');
	  list_label.GalleryAll=res.__('GalleryAll');
	  list_label.VideoAll=res.__('VideoAll');
  res.send(core.success(list_label));
});


module.exports = router;
