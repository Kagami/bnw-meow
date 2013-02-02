define [
  "chaplin"
  "models/base/model"
], (Chaplin, Model) ->
  "use strict"

  class Collection extends Chaplin.Collection

    urlRoot: Model::urlRoot
    url: ->
      "#{@urlRoot}/#{@id}"

    constructor: (models, options) ->
      super models, options
      @id = options.id if options?.id?
      @query = options.query if options?.query?

    apiCall: Model::apiCall
