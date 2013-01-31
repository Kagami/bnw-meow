define [
  "underscore"
  "chaplin"
  "lib/view_helpers"
], (_, Chaplin, view_helpers) ->
  "use strict"

  class View extends Chaplin.View

    # Could be overloaded in subclasses
    templateData: {}
    # Used for rendering with params
    _templateData2: {}

    render: (params) ->
      @_templateData2 = params
      super

    getTemplateData: ->
      data = super
      _(data).extend view_helpers, @templateData, @_templateData2

    getTemplateFunction: ->
      @template
