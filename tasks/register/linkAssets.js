module.exports = function (grunt) {
	grunt.registerTask('linkAssets', [
		'sails-linker:devFrontendJs',
		'sails-linker:devAdminJs',
		'sails-linker:devFrontendStyles',
		'sails-linker:devAdminStyles',
	]);
};
