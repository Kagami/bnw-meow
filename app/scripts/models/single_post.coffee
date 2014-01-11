Model = require "models/base/model"
Comments = require "models/comments"
Post = require "models/post"

module.exports = class SinglePost extends Model
  id: "show"

  constructor: (attributes, options) ->
    super attributes, options
    @query = message: options.post, replies: 1, use_bl: 1
    @replies = new Comments()

  fetch: ->
    @apiCall().done (data) =>
      @set data.message
      @replies.reset data.replies, postUser: @get "user"

  destroy: Post::destroy

  getAttributes: Post::getAttributes
