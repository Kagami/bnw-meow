define [
  "models/base/collection"
  "models/post"
], (Collection, Post)  ->
  "use strict"

  class Posts extends Collection

    id: "show"
    model: Post

    fetch: ->
      @apiCall().done (data) =>
        @add data.messages.reverse()
        if data.messages.length < @pageSize
          @_hasPages = false

    isEmptyPage: (data) ->
      not data.messages.length
