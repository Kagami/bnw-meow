define [
  "chaplin"
  "models/base/model"
], (Chaplin, Model) ->
  "use strict"

  class Collection extends Chaplin.Collection

    urlRoot: Model::urlRoot
    url: ->
      "#{@urlRoot}/#{@id}"
