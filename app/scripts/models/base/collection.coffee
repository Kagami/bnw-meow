define [
  "chaplin"
  "models/base/model"
], (Chaplin, Model) ->
  "use strict"

  class Collection extends Chaplin.Collection

    constructor: (models, options) ->
      super models, options
      @id = options.id if options?.id?
      @query = if options?.query? then options.query else {}

    apiCall: Model::apiCall

    #: Normal page size (number of elements). It could be smaller
    #: (on last page) but not bigger.
    pageSize: 20
    #: Set this var to false when you've reached
    #: the last page.
    _hasPages: true

    hasPages: ->
      ###Do we reach the last page?
      May be overloaded in descendants.
      ###
      @_hasPages

    incPage: ->
      if @query.page?
        @query.page++
      else
        @query.page = 1

    resetPages: ->
      @_hasPages = true
      delete @query.page

    isEmptyPage: (data) ->
      throw new Error "Collection#isEmptyPage must be overridden"
