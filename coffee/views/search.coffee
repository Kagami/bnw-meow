define [
  "jquery"
  "views/base/scrollable"
  "views/search_item"
  "lib/utils"
  "templates/search"
], ($, ScrollableView, SearchItemView, utils, template) ->
  "use strict"

  class SearchView extends ScrollableView

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
      input = @$(".search-form2-query").prop("disabled", true).blur()
      query = input.val()
      submit = @$(".search-form2-submit").prop("disabled", true)
      $("#search").empty()

      @publishEvent "!router:changeURL", "/search/#{encodeURIComponent query}"
      @publishEvent "!adjustTitle", "Поиск #{utils.truncate query}"
      @collection.setQuery query
      @fetch().always ->
        input.prop("disabled", false)
        submit.prop("disabled", false)
