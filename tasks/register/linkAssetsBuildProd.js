module.exports = function (grunt) {
	grunt.registerTask('linkAssetsBuildProd', [
		'sails-linker:prodFrontendJsRelative',
		'sails-linker:prodFrontendStylesRelative',
		'sails-linker:prodAdminJsRelative',
		'sails-linker:prodAdminStylesRelative',
	]);
};
