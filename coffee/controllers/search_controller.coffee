define [
  "chaplin"
  "models/search"
  "views/search"
  "views/header"
  "lib/utils"
], (Chaplin, Search, SearchView, HeaderView, utils) ->
  "use strict"

  class SearchController extends Chaplin.Controller

    show: (params) ->
      query = utils.decode params.query
      @collection = new Search()
      @view = new SearchView {@collection, query}
      HeaderView::updateBreadcrumbs []
