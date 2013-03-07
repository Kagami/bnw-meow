define [
  "views/base/collection_view"
  "views/search_item"
  "lib/utils"
  "templates/search"
], (CollectionView, SearchItemView, utils, template) ->
  "use strict"

  class SearchView extends CollectionView

    container: "#main"
    template: template
    listSelector: "#search"
    itemView: SearchItemView
    events:
      "submit .search-form2": "search"

    initialize: (options) ->
      super options
      # Initial query
      @_query = options.query

    afterRender: ->
      super
      @$(".search-form2-query").val(@_query)
      @search()

    search: (e = undefined) ->
      e.preventDefault() if e?
      query = @$(".search-form2-query").val()
      @publishEvent "!router:changeURL", "/search/#{encodeURIComponent query}"
      @publishEvent "!adjustTitle", "Поиск #{utils.truncate query}"
      @collection.search query
