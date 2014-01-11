define [
  "underscore"
  "chaplin"
  "views/base/view"
  "lib/websocket_handler"
  "lib/view_helpers"
], (_, Chaplin, View, WebSocketHandler, viewHelpers) ->
  "use strict"

  # We need to copypaste some helpers from View class because
  # otherwise it will use wrong 'super'.

  class CollectionView extends Chaplin.CollectionView

    _(@prototype).extend WebSocketHandler

    animationDuration: 300

    # Could be overloaded in subclasses
    templateData: {}
    # Used for rendering with params
    _templateData2: {}

    dispose: ->
      @closeWebSocket()
      super

    render: (params = {}) ->
      @_templateData2 = params
      super

    getTemplateData: ->
      data = super
      templateData = if typeof @templateData is "function"
        @templateData()
      else
        @templateData
      _(data).extend viewHelpers, templateData, @_templateData2

    getTemplateFunction: View::getTemplateFunction
