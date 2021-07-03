var i18n = require('i18n');

i18n.configure({
  // setup some locales - other locales default to en silently
  locales:['vi', 'en'],
 register:global,

  // where to store json files - defaults to './locales' relative to modules directory
  directory:__dirname + '/locales',
  
  defaultLocale: 'vi',
  autoReload:true,
 
  queryParameter:'lang',
  // sets a custom cookie name to parse locale settings from  - defaults to NULL
  cookie: 'lang',
  api:{
	'__':'__',
	'__n':'__n'
}
});

module.exports = function(req, res, next) {

  i18n.init(req, res);
  
  var current_locale = i18n.getLocale();

 next();
};