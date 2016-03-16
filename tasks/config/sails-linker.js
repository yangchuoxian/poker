/**
 * Autoinsert script tags (or other filebased tags) in an html file.
 *
 * ---------------------------------------------------------------
 *
 * Automatically inject <script> tags for javascript files and <link> tags
 * for css files.  Also automatically links an output file containing precompiled
 * templates using a <script> tag.
 *
 * For usage docs see:
 *        https://github.com/Zolmeister/grunt-sails-linker
 *
 */
module.exports = function (grunt) {

    grunt.config.set('sails-linker', {
        devFrontendJs: {
            options: {
                startTag: '<!--SCRIPTS-->',
                endTag: '<!--SCRIPTS END-->',
                fileTmpl: '<script src="%s"></script>',
                appRoot: '.tmp/public'
            },
            files: {
                'views/frontend_pages/*.html': require('../pipeline').frontendJsFilesToInject,
                'views/frontend_pages/*.ejs': require('../pipeline').frontendJsFilesToInject
            }
        },
        devFrontendJsRelative: {
            options: {
                startTag: '<!--SCRIPTS-->',
                endTag: '<!--SCRIPTS END-->',
                fileTmpl: '<script src="%s"></script>',
                appRoot: '.tmp/public',
                relative: true
            },
            files: {
                'views/frontend_pages/*.html': require('../pipeline').frontendJsFilesToInject,
                'views/frontend_pages/*.ejs': require('../pipeline').frontendJsFilesToInject
            }
        },
        devAdminJs: {
            options: {
                startTag: '<!--SCRIPTS-->',
                endTag: '<!--SCRIPTS END-->',
                fileTmpl: '<script src="%s"></script>',
                appRoot: '.tmp/public'
            },
            files: {
                'views/admin_pages/*.html': require('../pipeline').adminJsFilesToInject,
                'views/admin_pages/*.ejs': require('../pipeline').adminJsFilesToInject
            }
        },
        devAdminJsRelative: {
            options: {
                startTag: '<!--SCRIPTS-->',
                endTag: '<!--SCRIPTS END-->',
                fileTmpl: '<script src="%s"></script>',
                appRoot: '.tmp/public',
                relative: true
            },
            files: {
                'views/admin_pages/*.html': require('../pipeline').adminJsFilesToInject,
                'views/admin_pages/*.ejs': require('../pipeline').adminJsFilesToInject
            }
        },
        prodFrontendJs: {
            options: {
                startTag: '<!--SCRIPTS-->',
                endTag: '<!--SCRIPTS END-->',
                fileTmpl: '<script src="%s"></script>',
                appRoot: '.tmp/public'
            },
            files: {
                'views/frontend_pages/*.html': ['.tmp/public/js/frontend/production.frontend.min.js'],
                'views/frontend_pages/*.ejs': ['.tmp/public/js/frontend/production.frontend.min.js']
            }
        },
        prodFrontendJsRelative: {
            options: {
                startTag: '<!--SCRIPTS-->',
                endTag: '<!--SCRIPTS END-->',
                fileTmpl: '<script src="%s"></script>',
                appRoot: '.tmp/public',
                relative: true
            },
            files: {
                'views/frontend_pages/*.html': ['.tmp/public/js/frontend/production.frontend.min.js'],
                'views/frontend_pages/*.ejs': ['.tmp/public/js/frontend/production.frontend.min.js']
            }
        },


        prodAdminJs: {
            options: {
                startTag: '<!--SCRIPTS-->',
                endTag: '<!--SCRIPTS END-->',
                fileTmpl: '<script src="%s"></script>',
                appRoot: '.tmp/public'
            },
            files: {
                'views/admin_pages/*.html': ['.tmp/public/js/admin/production.admin.min.js'],
                'views/admin_pages/*.ejs': ['.tmp/public/js/admin/production.admin.min.js']
            }
        },
        prodAdminJsRelative: {
            options: {
                startTag: '<!--SCRIPTS-->',
                endTag: '<!--SCRIPTS END-->',
                fileTmpl: '<script src="%s"></script>',
                appRoot: '.tmp/public',
                relative: true
            },
            files: {
                'views/admin_pages/*.html': ['.tmp/public/js/admin/production.admin.min.js'],
                'views/admin_pages/*.ejs': ['.tmp/public/js/admin/production.admin.min.js']
            }
        },

        devFrontendStyles: {
            options: {
                startTag: '<!--STYLES-->',
                endTag: '<!--STYLES END-->',
                fileTmpl: '<link rel="stylesheet" href="%s">',
                appRoot: '.tmp/public'
            },

            files: {
                'views/frontend_pages/*.html': require('../pipeline').frontendCssFilesToInject,
                'views/frontend_pages/*.ejs': require('../pipeline').frontendCssFilesToInject
            }
        },
        devFrontendStylesRelative: {
            options: {
                startTag: '<!--STYLES-->',
                endTag: '<!--STYLES END-->',
                fileTmpl: '<link rel="stylesheet" href="%s">',
                appRoot: '.tmp/public',
                relative: true
            },

            files: {
                'views/frontend_pages/*.html': require('../pipeline').frontendCssFilesToInject,
                'views/frontend_pages/*.ejs': require('../pipeline').frontendCssFilesToInject
            }
        },

        devAdminStyles: {
            options: {
                startTag: '<!--STYLES-->',
                endTag: '<!--STYLES END-->',
                fileTmpl: '<link rel="stylesheet" href="%s">',
                appRoot: '.tmp/public'
            },

            files: {
                'views/admin_pages/*.html': require('../pipeline').adminCssFilesToInject,
                'views/admin_pages/*.ejs': require('../pipeline').adminCssFilesToInject
            }
        },
        devAdminStylesRelative: {
            options: {
                startTag: '<!--STYLES-->',
                endTag: '<!--STYLES END-->',
                fileTmpl: '<link rel="stylesheet" href="%s">',
                appRoot: '.tmp/public',
                relative: true
            },

            files: {
                'views/admin_pages/*.html': require('../pipeline').adminCssFilesToInject,
                'views/admin_pages/*.ejs': require('../pipeline').adminCssFilesToInject
            }
        },

        prodFrontendStyles: {
            options: {
                startTag: '<!--STYLES-->',
                endTag: '<!--STYLES END-->',
                fileTmpl: '<link rel="stylesheet" href="%s">',
                appRoot: '.tmp/public'
            },
            files: {
                '.tmp/public/index.html': ['.tmp/public/styles/frontend/production.frontend.min.css'],
                'views/frontend_pages/*.html': ['.tmp/public/styles/frontend/production.frontend.min.css'],
                'views/frontend_pages/*.ejs': ['.tmp/public/styles/frontend/production.frontend.min.css']
            }
        },
        prodFrontendStylesRelative: {
            options: {
                startTag: '<!--STYLES-->',
                endTag: '<!--STYLES END-->',
                fileTmpl: '<link rel="stylesheet" href="%s">',
                appRoot: '.tmp/public',
                relative: true
            },
            files: {
                '.tmp/public/index.html': ['.tmp/public/styles/frontend/production.frontend.min.css'],
                'views/frontend_pages/*.html': ['.tmp/public/styles/frontend/production.frontend.min.css'],
                'views/frontend_pages/*.ejs': ['.tmp/public/styles/frontend/production.frontend.min.css']
            }
        },

        prodAdminStyles: {
            options: {
                startTag: '<!--STYLES-->',
                endTag: '<!--STYLES END-->',
                fileTmpl: '<link rel="stylesheet" href="%s">',
                appRoot: '.tmp/public'
            },
            files: {
                'views/admin_pages/*.html': ['.tmp/public/styles/admin/production.admin.min.css'],
                'views/admin_pages/*.ejs': ['.tmp/public/styles/admin/production.admin.min.css']
            }
        },
        prodAdminStylesRelative: {
            options: {
                startTag: '<!--STYLES-->',
                endTag: '<!--STYLES END-->',
                fileTmpl: '<link rel="stylesheet" href="%s">',
                appRoot: '.tmp/public',
                relative: true
            },
            files: {
                'views/admin_pages/*.html': ['.tmp/public/styles/admin/production.admin.min.css'],
                'views/admin_pages/*.ejs': ['.tmp/public/styles/admin/production.admin.min.css']
            }
        }
    });

    grunt.loadNpmTasks('grunt-sails-linker');
};
