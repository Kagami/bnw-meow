define [
  "underscore"
  "config"
  "lib/utils"
], (_, config, utils) ->
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
    _wsTries: 0

    isWsAvailable: ->
      return false unless WebSocket?
      path = window.location.pathname
      cut = path[...3]
      _.any [
        # Main
        cut == "/"
        # Top
        path == "/top"
        # Feed
        path == "/feed"
        # User page
        _.all [
          cut == "/u/"
          # TODO: Allow websockets on urls like /u/user/t/tag
          # It will require some additional work like determine
          # does the added post tags meet the criteria of the
          # current tag, fixing getBnwWsUrl and so on.
          path.indexOf("/t/") == -1
          # TODO: Allow websockets on /all and /recommendations
          # subpages.
          @show == "messages"
        ]

        # Post page
        cut == "/p/"
      ]

    getBnwWsUrl: ->
      path = window.location.pathname
      path = "" if _.contains [
          "/"
          "/top"
          "/feed"
        ], path
      "#{config.BNW_WS_PROTOCOL}://#{config.BNW_WS_HOST}#{path}/ws?v=2"

    initWebSocket: ->
      return unless @isWsAvailable()
      wsUrl = @getBnwWsUrl()
      @ws = new WebSocket wsUrl

      @ws.onopen = (e) =>
        msg = "[#{utils.now()}] Вебсокет #{wsUrl} открыт"
        console.info msg
        # Let it to fail one time without notice
        if @_wsTries > 1
          utils.showAlert msg, "success", false
        @_wsTries = 0

      @ws.onclose = (e) =>
        msg = "[#{utils.now()}] Вебсокет #{wsUrl} закрыт"
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
