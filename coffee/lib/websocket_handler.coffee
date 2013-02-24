define [
  "underscore"
  "lib/utils"
], (_, utils) ->
  "use strict"

  # TODO: Use it in the base view/collection_view.

  WebSocketHandler =
    ###Helper mixin for adding websocket functionality to the
    target class and handling messages arrived via websocket.
    ###

    # Reopening constants (delays in milliseconds)
    WS_TRIES_FAST: 5
    WS_TRIES_FAST_DELAY: 2000
    WS_TRIES_SLOW: 120
    WS_TRIES_SLOW_DELAY: 30000
    _wsTries: 0

    isWsAvailable: ->
      _.all [
        WebSocket?
        window.location.pathname[...3] in ["/", "/u/", "/p/"]
      ]

    initWebSocket: ->
      return unless @isWsAvailable()
      @wsUrl = utils.bnwWsUrl()
      @ws = new WebSocket @wsUrl

      @ws.onopen = (e) =>
        msg = "[#{utils.now()}] Вебсокет #{@wsUrl} открыт"
        console.info msg
        if @_wsTries
          utils.showAlert msg, "success", false
        @_wsTries = 0

      @ws.onclose = (e) =>
        msg = "[#{utils.now()}] Вебсокет #{@wsUrl} закрыт"
        console.info msg
        return if @disposed
        if @_wsTries == 1
          utils.showAlert msg, "error", false
        if @_wsTries < @WS_TRIES_FAST
          delay = @WS_TRIES_FAST_DELAY
        else if @_wsTries < @WS_TRIES_SLOW
          delay = @WS_TRIES_SLOW_DELAY
        else
          return
        @_wsTries++
        setTimeout (=> @initWebSocket() unless @disposed), delay

      @ws.onmessage = (e) =>
        data = JSON.parse e.data
        @publishEvent "!ws:#{data.type}", data
        @publishEvent "!ws:#{data.type}:#{data.id}", data

    closeWebSocket: ->
      @ws.close() if @ws?
