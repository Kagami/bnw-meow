define [
  "jquery"
  "views/base/scrollable"
  "views/search_item"
  "lib/utils"
  "templates/search"
  "templates/no_search_items"
], ($, ScrollableView, SearchItemView, utils, template, notFound) ->
  "use strict"

  class SearchView extends ScrollableView

    container: "#main"
    template: template
    listSelector: "#search"
    itemView: SearchItemView
    events:
      "submit .search-form2": "search"
    notFoundTemplate: notFound

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
      input = @$(".search-form2-query").prop("disabled", true)
      query = input.val()
      submit = @$(".search-form2-submit").prop("disabled", true)
      $("#search").empty()

      @publishEvent "!router:changeURL", "/search/#{utils.encode query}"
      @publishEvent "!adjustTitle", "Поиск #{utils.truncate query}"
      @collection.setQuery query
      d = @fetch()
      d.always ->
        input.prop("disabled", false)
        submit.prop("disabled", false)
      d.done (data) =>
        unless @collection.isEmptyPage data
          n = data.estimated
          w1 = utils.pluralForm n, ["Найден", "Найдено", "Найдено"]
          w2 = utils.pluralForm n, ["результат", "результата", "результатов"]
          $("<p/>").addClass("estimated")
                   .text("#{w1} #{n} #{w2}.")
                   .prependTo($("#search"))
