/**
 * grunt/pipeline.js
 *
 * The order in which your css, javascript, and template files should be
 * compiled and linked from your views and static HTML files.
 *
 * (Note that you can take advantage of Grunt-style wildcard/glob/splat expressions
 * for matching multiple files.)
 */



var frontendCssFilesToInject = [
	'styles/frontend/*.css'
];

var frontendJsFilesToInject = [
	'js/dependencies/sails.io.js',
	'js/dependencies/angular.min.js',
	'js/dependencies/ui-bootstrap.js',
	'js/dependencies/angular-ui-router.min.js',
	'js/dependencies/ocLazyLoad.min.js',
	'js/frontend/frontend.js',
	'js/dependencies/phaser.min.js'
];

var adminCssFilesToInject = [
	'styles/admin/*.css'
];

var adminJsFilesToInject = [
	'js/admin/*.js'
];

var templateFilesToInject = [
	'templates/**/*.html'
];

var fontFilesToInject = [
	'styles/fonts/*'
];


// Prefix relative paths to source files so they point to the proper locations
// (i.e. where the other Grunt tasks spit them out, or in some cases, where
// they reside in the first place)
module.exports.frontendCssFilesToInject = frontendCssFilesToInject.map(function(path) {
	return '.tmp/public/' + path;
});
module.exports.frontendJsFilesToInject = frontendJsFilesToInject.map(function(path) {
	return '.tmp/public/' + path;
});

module.exports.adminCssFilesToInject = adminCssFilesToInject.map(function(path) {
	return '.tmp/public/' + path;
});
module.exports.adminJsFilesToInject = adminJsFilesToInject.map(function(path) {
	return '.tmp/public/' + path;
});

module.exports.templateFilesToInject = templateFilesToInject.map(function(path) {
	return 'assets/' + path;
});
