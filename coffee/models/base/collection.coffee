define [
  "chaplin"
  "models/base/model"
], (Chaplin, Model) ->
  "use strict"

  class Collection extends Chaplin.Collection

    constructor: (models, options) ->
      super models, options
      @id = options.id if options?.id?
      @query = options.query if options?.query?

    apiCall: Model::apiCall

    #: Set this var to false when you've reached
    #: the last page.
    _hasPages: true

    hasPages: ->
      ###Do we reach the last page?###
      @_hasPages

    incPage: ->
      if @query.page?
        @query.page++
      else
        @query.page = 1
