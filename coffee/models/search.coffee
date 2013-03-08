define [
  "models/base/collection"
  "models/search_item"
], (Collection, SearchItem)  ->
  "use strict"

  class Search extends Collection

    id: "search"
    model: SearchItem

    fetch: ->
      @apiCall().done (data) =>
        @add data.results
        if data.results.length < @pageSize
          @_hasPages = false

    setQuery: (query) ->
      @reset()
      @resetPages()
      # API request URI looks like /api/search/?query=<search_query>
      # We have the similar collection's options parameter so
      # it's a bit confusing.
      @query = {query}

    isEmptyPage: (data) ->
      not data.results.length
