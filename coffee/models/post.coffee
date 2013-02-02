define [
  "moment"
  "models/base/model"
], (moment, Model)  ->
  "use strict"

  class Post extends Model

    getAttributes: ->
      _({}).extend @attributes,
        date: moment.unix(@get "date")
