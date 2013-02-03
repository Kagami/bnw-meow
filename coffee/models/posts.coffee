define [
  "models/base/collection"
  "models/post"
], (Collection, Post)  ->
  "use strict"

  class Posts extends Collection

    id: "show"
    model: Post

    fetch: ->
      # XXX: What the fuck is that API format?
      @apiCall().done (data) =>
        @reset data.messages.reverse()
