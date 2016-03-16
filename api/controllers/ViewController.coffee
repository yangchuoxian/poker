###
ViewController

@description :: Server-side logic for managing views
@help        :: See http://links.sailsjs.org/docs/controllers
###

module.exports =
    showIndexPage: (req, res) ->
        res.locals.layout = 'frontend_pages/frontend_layout'
        res.view 'frontend_pages/index'