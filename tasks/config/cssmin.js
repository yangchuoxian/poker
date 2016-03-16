/**
 * Compress CSS files.
 *
 * ---------------------------------------------------------------
 *
 * Minifies css files and places them into .tmp/public/min directory.
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-cssmin
 */
module.exports = function(grunt) {

	grunt.config.set('cssmin', {
		frontendDist: {
		    src: ['.tmp/public/styles/frontend/production.frontend.css'],
		    dest: '.tmp/public/styles/frontend/production.frontend.min.css'
		},
		adminDist: {
		    src: ['.tmp/public/styles/admin/production.admin.css'],
		    dest: '.tmp/public/styles/admin/production.admin.min.css'
		}
	});

	grunt.loadNpmTasks('grunt-contrib-cssmin');
};
