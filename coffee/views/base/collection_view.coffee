define [
  "underscore"
  "chaplin"
  "views/base/view"
  "lib/websocket_handler"
], (_, Chaplin, View, WebSocketHandler) ->
  "use strict"

  class CollectionView extends Chaplin.CollectionView

    _(@prototype).extend WebSocketHandler

    animationDuration: 300

    getTemplateFunction: View::getTemplateFunction

    dispose: ->
      @closeWebSocket()
      super
