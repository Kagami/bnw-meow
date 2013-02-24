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
        if data.messages.length
          @add data.messages.reverse()
        else
          @_hasPages = false
