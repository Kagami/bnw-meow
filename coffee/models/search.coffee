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
        @reset data.search_result[1]

    search: (query) ->
      # API request URI looks like /api/search/?query=<search_query>
      # We have the similar collection's options parameter so
      # it's a bit confusing.
      @query = {query}
      @fetch()
