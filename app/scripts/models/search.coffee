Collection = require "models/base/collection"
SearchItem = require "models/search_item"

module.exports = class Search extends Collection
  id: "search"
  model: SearchItem

  fetch: ->
    d = @apiCall()
    d.done (data) =>
      @add data.results
      if data.results.length < @pageSize
        @_hasPages = false
    d.fail =>
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
