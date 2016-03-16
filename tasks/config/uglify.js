/**
 * Minify files with UglifyJS.
 *
 * ---------------------------------------------------------------
 *
 * Minifies client-side javascript `assets`.
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-uglify
 *
 */
module.exports = function(grunt) {

	grunt.config.set('uglify', {
		adminDist: {
		    src: ['.tmp/public/js/admin/production.admin.js'],
		    dest: '.tmp/public/js/admin/production.admin.min.js'
		},
		frontendDist: {
		    src: ['.tmp/public/js/frontend/production.frontend.js'],
		    dest: '.tmp/public/js/frontend/production.frontend.min.js'
		}
	});

	grunt.loadNpmTasks('grunt-contrib-uglify');
};
