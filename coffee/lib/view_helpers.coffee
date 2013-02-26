define [
  "jquery"
  "underscore"
  "config"
], ($, _, config) ->
  "use strict"

  viewHelpers =

    bnwUrl: (path) ->
      "#{config.BNW_API_PROTOCOL}://#{config.BNW_API_HOST}#{path}"

    bnwWsUrl: (path = window.location.pathname) ->
      path = "" if path == "/"
      "#{config.BNW_WS_PROTOCOL}://#{config.BNW_WS_HOST}#{path}/ws?v=2"

    renderTemplate: (templateFunc, params = {}) =>
      templateFunc _(params).extend(this)

    formatDate: (date) ->
      moment.unix(date).fromNow()

    formatDateLong: (date) ->
      moment.unix(date).format("YYYY-MM-DD HH:mm:ss")

    truncate: (text, maxlength = 50) ->
      if text.length > maxlength
        text[...maxlength].concat "…"
      else
        text

    clipUrl: (url) ->
      if url.length > 55
          url = url[...40] + "....." + url[-10..]
      url

    escape2: (html) ->
      # We need our NIH function here because underscore do some crappy
      # things with slashes.
      html.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;").replace(/'/g, "&apos;")

    formatText: (raw) ->
      ###Format post/comment text.
      Use simple regexp formatters.
      Reference:
      <https://github.com/stiletto/bnw/blob/master/bnw_web/linkify.py>
      ###

      textFormatters = [
        # Code
        [/{{{(?:#!(\w+)\s)?([^]+?)}}}/, (_m, lang, code) ->
          klass = if lang then " class=\"language-#{lang}\"" else ""
          "<pre><code#{klass}>#{code}</code></pre>"
        ]
        # Italic
        [/(^|\s)\/\/([^]+?)\/\/(\s|$)/g, (_m, s1, content, s2) ->
          "#{s1}<i>#{content}</i>#{s2}"
        ]
        # Bold
        [/(^|\s)\*\*([^]+?)\*\*(\s|$)/g, (_m, s1, content, s2) ->
          "#{s1}<b>#{content}</b>#{s2}"
        ]
        # Named link
        [/\[\[\s*(.+?)\s*\|\s*(.+?)\s*\]\]/g, (_m, url, link_text) ->
          "<a href=\"#{url}\">#{link_text}</a>"
        ]
        # URL
        [/(^|&lt;|[\s\(\[])(https?:\/\/[^\]\)\s]+)/g, (_m, ch, url) =>
          # XXX: Don't know how to write regexp for it.
          # Since we do text escaping before additional
          # formatting.
          indexes = [
            url.indexOf "&gt;"
            url.indexOf "&quot;"
            url.indexOf "&apos;"
          ]
          if indexes == [-1, -1, -1]
            urlText = @clipUrl url
            "#{ch}<a href=\"#{url}\">#{urlText}</a>"
          else
            i = Math.min _(indexes).without(-1)...
            [url, tail] = [url[...i], url[i..]]
            urlText = @clipUrl url
            "#{ch}<a href=\"#{url}\">#{urlText}</a>#{tail}"
        ]
        # User
        [/(^|\s)@([-0-9A-Za-z_]+)/g, (_m, space, user) ->
          "#{space}<a href=\"/u/#{user}\">@#{user}</a>"
        ]
        # Post/comment link
        [/(^|\s)#([0-9A-Za-z]+(?:\/[0-9A-Za-z]+)?)/g, (_m, space, link) ->
          "#{space}<a href=\"/p/#{link.replace '/', '#'}\">##{link}</a>"
        ]
        # Fix newlines
        [/\n/g, -> "<br />"]
      ]

      # Very-very important line, don't ever try to touch it
      text = @escape2 raw

      # Go throw all defined formatters.
      _(textFormatters).reduce (tmpText, [regexp, handler]) ->
        tmpText.replace regexp, handler
      , text

    isLogged: ->
      $.cookie("login")?

    getUser: ->
      $.cookie "user"
