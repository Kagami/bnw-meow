define [
  "jquery"
  "models/base/collection"
  "models/post"
], ($, Collection, Post)  ->
  "use strict"

  class Posts extends Collection

    id: "show"
    model: Post

    constructor: (models, options) ->
      super models, options
      @id = options.id if options?.id?

    fetch: ->
      # XXX: What the fuck is that API format?
      @apiCall().done (data) =>
        @reset data.messages.reverse()
