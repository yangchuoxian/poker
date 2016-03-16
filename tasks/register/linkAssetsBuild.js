module.exports = function (grunt) {
	grunt.registerTask('linkAssetsBuild', [
		'sails-linker:devFrontendJsRelative',
		'sails-linker:devAdminJsRelative',
		'sails-linker:devFrontendStylesRelative',
		'sails-linker:devAdminStylesRelative'
	]);
};
