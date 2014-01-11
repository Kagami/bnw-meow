Chaplin = require "chaplin"
Search = require "models/search"
SearchView = require "views/search"
HeaderView = require "views/header"
utils = require "lib/utils"

module.exports = class SearchController extends Chaplin.Controller
  show: (params) ->
    query = utils.decode params.query
    @collection = new Search()
    @view = new SearchView {@collection, query}
    HeaderView::updateBreadcrumbs []
