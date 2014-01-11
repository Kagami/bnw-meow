define [
  "jquery"
  "views/base/scrollable"
  "views/search_item"
  "views/base/datepicker"
  "lib/utils"
  "templates/search"
  "templates/no_search_items"
], ($, ScrollableView, SearchItemView, DatePickerView, utils, template,
    notFound) ->
  "use strict"

  class SearchView extends ScrollableView

    container: "#main"
    template: template
    listSelector: "#search"
    itemView: SearchItemView
    events:
      "submit .search-form2": "search"
      "click .search-form2-toggle-additional": "toggleAdditional"
    notFoundTemplate: notFound

    initialize: (options) ->
      super options
      # Set initial query
      @_query = options.query

    afterRender: ->
      super
      @applyInitialQuery()
      new DatePickerView el: $("#search-form2-date-from")
      new DatePickerView el: $("#search-form2-date-to")
      @search()

    applyInitialQuery: ->
      ###Parse additional search parameters from the end of search
      line and set appropriate input values.
      ###
      match = @_query.match /\w+:.|[\d\/]{10}\.\.|\.\.[\d\/]{10}/
      if match?
        i = match.index
        base = @_query[...i]
        rest = @_query[i..]

        type = rest.match /type:(.)/
        if type?
          r = @$(".search-form-additional [value='#{type[1]}']")
          r.prop("checked", true)

        user = rest.match /user:([^\s]+)/
        if user?
          $("#search-form2-user").val(user[1])

        tags = rest.match /tags:\((.+?)\)/
        if tags?
          $("#search-form2-tags").val(tags[1])

        clubs = rest.match /clubs:\((.+?)\)/
        if clubs?
          $("#search-form2-clubs").val(clubs[1])

        date = rest.match /([\d\/]{10})?\.\.([\d\/]{10})?/
        if date?
          $("#search-form2-date-from").val(date[1]) if date[1]?
          $("#search-form2-date-to").val(date[2]) if date[2]?

        @toggleAdditional()
      else
        base = @_query
      $("#search-form2-query").val(base.trim())

    getFullQuery: ->
      result = []

      base = $("#search-form2-query").val()
      result.push base if base.length

      type = @$(".search-form-additional [name='type']:checked").val()
      result.push "type:#{type}" if type isnt "all"

      user = $("#search-form2-user").val()
      result.push "user:#{user}" if user.length

      tags = $("#search-form2-tags").val()
      result.push "tags:(#{tags})" if tags.length

      clubs = $("#search-form2-clubs").val()
      result.push "clubs:(#{clubs})" if clubs.length

      from = $("#search-form2-date-from").val()
      to = $("#search-form2-date-to").val()
      date = "#{from}..#{to}"
      result.push date if date isnt ".."

      result.join " "

    search: (e = undefined) ->
      e.preventDefault() if e?
      query = @getFullQuery()
      return unless query.length

      $("#search").empty()
      buttons = @$(".search-form2 button").prop("disabled", true)
      @publishEvent "!router:changeURL", "/search/#{utils.encode query}"
      @publishEvent "!adjustTitle", "Поиск #{utils.truncate query}"
      @collection.setQuery query
      d = @fetch()
      d.always ->
        buttons.prop("disabled", false)
      d.done (data) =>
        unless @collection.isEmptyPage data
          n = data.estimated
          w1 = utils.pluralForm n, ["Найден", "Найдено", "Найдено"]
          w2 = utils.pluralForm n, ["результат", "результата", "результатов"]
          $("<p/>").addClass("estimated")
                   .text("#{w1} #{n} #{w2}.")
                   .prependTo($("#search"))

    toggleAdditional: ->
      @$(".search-form-additional").toggle("fast")
      @$(".search-form2-toggle-additional").toggleClass("active")
