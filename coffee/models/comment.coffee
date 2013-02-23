define [
  "underscore"
  "models/base/model"
], (_, Model)  ->
  "use strict"

  class Comment extends Model

    constructor: (models, options) ->
      super models, options
      @postUser = options.postUser

    destroy: ->
      @apiCall "delete", message: @get "id"

    getAttributes: ->
      commentId = @get("id").split("/")[1]
      _({commentId}).extend @attributes
