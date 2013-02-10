define [
  "lib/utils"
], (utils) ->
  "use strict"

  WebSocketHandler =
    ###Helper mixin for adding websocket functionality to the
    target class and handling messages arrived via websocket.
    ###

    isWsAvailable: ->
      window.location.pathname[...3] in ["/", "/u/", "/p/"]

    initWebSocket: ->
      return unless @isWsAvailable()
      # FIXME: Auto reconnects!
      @ws = new WebSocket utils.bnwWsUrl()
      # Check arrived message type and try to find appropriate callback
      # to handle it.
      @ws.onmessage = (e) =>
        message = JSON.parse e.data
        type = message.type
        # new_comment -> onNewComment
        type = "on" + type.replace /(?:^|_)(.)/g, (_m, p1) -> p1.toUpperCase()
        handler = @[type]
        handler.call this, message if handler?
