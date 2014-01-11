Collection = require "models/base/collection"
Post = require "models/post"

module.exports = class Posts extends Collection
  id: "show"
  model: Post

  fetch: ->
    @apiCall().done (data) =>
      @add data.messages.reverse()
      if data.messages.length < @pageSize
        @_hasPages = false

  isEmptyPage: (data) ->
    not data.messages.length
