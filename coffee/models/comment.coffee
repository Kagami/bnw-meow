define [
  "moment"
  "models/base/model"
], (moment, Model)  ->
  "use strict"

  class Comment extends Model

    constructor: (models, options) ->
      super models, options
      @postUser = options.postUser
