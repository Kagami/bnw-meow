define [
  "underscore"
], (_) ->
  "use strict"

  viewHelpers =

    BNW_HOST: "bnw.im"

    bnwUrl: (path) ->
      "https://#{@BNW_HOST}#{path}"

    bnwWsUrl: (path = window.location.pathname) ->
      path = "" if path == "/"
      "wss://#{@BNW_HOST}#{path}/ws?v=2"

    renderTemplate: (templateFunc, params={}) =>
      templateFunc _(params).extend(this)

    formatDate: (date) ->
      moment.unix(date).fromNow()

    formatDateLong: (date) ->
      moment.unix(date).format("YYYY-MM-DD HH:mm:ss")

    formatPostTitle: (text) ->
      if text.length > 50
        text[...50] + "…"
      else
        text

    escape2: (html) ->
      # We need our NIH function here because underscore do some crappy
      # things with slashes.
      html.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")

    formatText: (raw) ->
      ###Format post/comment text.
      Use simple regexp formatters.
      Reference:
      <https://github.com/stiletto/bnw/blob/master/bnw_web/linkify.py>
      ###

      textFormatters = [
        # Italic
        [/\/\/(.+?)\/\//g, (_m, content) -> "<i>#{content}</i>"]
        # Bold
        [/\*\*(.+?)\*\*/g, (_m, content) -> "<b>#{content}</b>"]
        # Named link
        [/\[\[\s*(.+?)\s*\|\s*(.+?)\s*\]\]/g
         (_m, url, link_text) -> "<a href=\"#{url}\">#{link_text}</a>"]
        # URL
        # FIXME: Seems like regexp for urls could be better
        [/(^|\s)(https?:\/\/[^'"\s>]+)/g,
         (_m, space, url) -> "#{space}<a href=\"#{url}\">#{url}</a>"]
        # User
        [/(^|\s)@([-0-9A-Za-z_]+)/g
         (_m, space, user) -> "#{space}<a href=\"/u/#{user}\">@#{user}</a>"]
        # Post/comment link
        [/(^|\s)#([0-9A-Za-z]+(?:\/[0-9A-Za-z]+)?)/g
         (_m, space, link) ->
           "#{space}<a href=\"/p/#{link.replace '/', '#'}\">##{link}</a>"]
        # Fix newlines
        [/\n/g, -> "<br />"]
      ]

      # Very-very important line, don't ever try to touch it
      text = @escape2 raw

      # Go throw all defined formatters.
      _(textFormatters).reduce (tmpText, [regexp, handler]) ->
        tmpText.replace regexp, handler
      , text

    getCommentId: (id) ->
      id.split("/")[1]
