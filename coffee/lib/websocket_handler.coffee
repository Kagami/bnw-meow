define [
  "lib/utils"
], (utils) ->
  "use strict"

  WebSocketHandler =
    ###Helper mixin for adding websocket functionality to the
    target class and handling messages arrived via websocket.
    ###

    # Reopening constants (delays in milliseconds)
    WS_TRIES_FAST: 5
    WS_TRIES_FAST_DELAY: 2000
    WS_TRIES_SLOW: 120
    WS_TRIES_SLOW_DELAY: 30000
    WS_TRIES_LAST_HOPE_DELAY: 600000
    _wsTries: 0

    isWsAvailable: ->
      window.location.pathname[...3] in ["/", "/u/", "/p/"]

    initWebSocket: ->
      return unless @isWsAvailable()
      @ws = new WebSocket utils.bnwWsUrl()

      @ws.onopen = (e) =>
        console.info "websocket #{utils.bnwWsUrl()} opened"
        @_wsTries = 0

      @ws.onclose = (e) =>
        console.warn "websocket #{utils.bnwWsUrl()} closed"
        return if @disposed
        if @_wsTries < @WS_TRIES_FAST
          delay = @WS_TRIES_FAST_DELAY
        else if @_wsTries < @WS_TRIES_SLOW
          delay = @WS_TRIES_SLOW_DELAY
        else
          delay = @WS_TRIES_LAST_HOPE_DELAY
        @_wsTries++
        setTimeout (=> @initWebSocket() unless @disposed), delay

      @ws.onmessage = (e) =>
        ###Check arrived message type and try to find appropriate
        callback to handle it.
        ###
        message = JSON.parse e.data
        type = message.type
        # new_comment -> onNewComment
        type = "on" + type.replace /(?:^|_)(.)/g, (_m, p1) -> p1.toUpperCase()
        handler = @[type]
        handler.call this, message if handler?
