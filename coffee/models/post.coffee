define [
  "models/base/model"
], (Model)  ->
  "use strict"

  class Post extends Model

    destroy: ->
      @apiCall "delete", message: @get "id"
