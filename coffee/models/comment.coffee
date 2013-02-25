define [
  "underscore"
  "models/base/model"
  "lib/utils"
], (_, Model, utils)  ->
  "use strict"

  class Comment extends Model

    constructor: (models, options) ->
      super models, options
      @postUser = options.postUser

    destroy: ->
      @apiCall "delete", message: @get "id"

    getAttributes: ->
      commentId = @get("id").split("/")[1]
      replyCommentId = @get("replyto")?.split("/")[1]
      canDelete = utils.getUser() in [@get("user"), @postUser]
      _({commentId, canDelete, replyCommentId}).extend @attributes
