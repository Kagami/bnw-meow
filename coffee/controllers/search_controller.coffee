define [
  "chaplin"
  "models/search"
  "views/search"
  "views/header"
], (Chaplin, Search, SearchView, HeaderView) ->
  "use strict"

  class SearchController extends Chaplin.Controller

    show: (params) ->
      query = decodeURIComponent params.query
      @collection = new Search()
      @view = new SearchView {@collection, query}
      HeaderView::updateBreadcrumbs []
