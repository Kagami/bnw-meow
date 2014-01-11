_ = require "underscore"
Chaplin = require "chaplin"
View = require "views/base/view"
WebSocketHandler = require "lib/websocket_handler"
viewHelpers = require "lib/view_helpers"

module.exports = class CollectionView extends Chaplin.CollectionView
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
