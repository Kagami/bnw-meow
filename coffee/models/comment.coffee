define [
  "models/base/model"
], (Model)  ->
  "use strict"

  class Comment extends Model

    constructor: (models, options) ->
      super models, options
      @postUser = options.postUser

    destroy: ->
      @apiCall "delete", message: @get "id"
