define [
  "models/base/model"
  "models/comments"
  "models/post"
], (Model, Comments, Post) ->
  "use strict"

  class SinglePost extends Model

    id: "show"

    constructor: (attributes, options) ->
      super attributes, options
      @query = message: options.post, replies: true
      @replies = new Comments()

    fetch: ->
      @apiCall().done (data) =>
        @set data.message
        @replies.reset data.replies, postUser: @get "user"

    destroy: Post::destroy

    getAttributes: Post::getAttributes
