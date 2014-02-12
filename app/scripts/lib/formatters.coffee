###
Formatters which convert post/comments markup into HTML for rendering
in templates.
Currently two formatters available: markdown and moinmoin. Them are
selected based on the post/comment 'format' parameter. Markdown is
preferred.
###

_ = require "underscore"
marked = require "marked"
viewHelpers = require "lib/view_helpers"

escape2 = (html) ->
  # We need our NIH function because underscore do some crappy
  # things with slashes.
  html.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;").replace(/'/g, "&#39;")

# XXX: Fix link renderer via monkey patching because it's the only
# way. Through issue with bad protocols should be fixed in upstream
# soon: <https://github.com/chjj/marked/issues/65>
# But not the images links! (We don't allow images.)
marked.InlineLexer::outputLink = (cap, link) ->
  # Allow only whitelisted protocols
  i = link.href.indexOf ":"
  if i != -1
    proto = link.href[...i]
    if proto not in ["http", "https", "ftp", "git","gopher",
                     "magnet", "mailto", "xmpp"]
      return @output link.href
  # Always generate links
  # Note that marked's escape function is slightly differ
  "<a href=\"#{escape2 link.href}\"" +
  (if link.title then "title=\"#{escape2 link.title}\"" else "") +
  ">" + @output(cap[1]) +
  "</a>"

module.exports =
  clipUrl: (url) ->
    if url.length > 85
        url = url[...60] + "....." + url[-20..]
    url

  escape2: escape2

  format: (raw, format = "markdown", reply = false) ->
    ###Format text using available formatters.

    :param format: default: "markdown". Specify text formatter.
                   Variants: "moinmoin", "markdown" or undefined,
                   which fallbacks to markdown.

    Return formatter string which should be inserted in DOM without
    any escaping.
    ###
    f = if format == "moinmoin" then @moinmoin else @markdown
    raw = raw.replace @FIX_REPLY_START[0], @FIX_REPLY_START[1] if reply
    f.call this, raw

  # Fix formatting at the first line of reply comment by deleting
  # reply nickname.
  # Actually API shouldn't do any actions with user text
  # (applying reply nickname is template work undoubtedly)
  # but fuck that legacy.
  FIX_REPLY_START:
    [/^[^ ]+ /, ""]

  USER_LINK_FORMATTER:
    [/(^|\s)@([-0-9A-Za-z_]+)/g
    , (_m, space, user) ->
      "#{space}<a href=\"/u/#{user}\">@#{user}</a>"
    , (_m, space, user) ->
      "#{space}[@#{user}](/u/#{user})"
    ]

  POST_LINK_FORMATTER:
    [/(^|\s)#([0-9A-Za-z]+(?:\/[0-9A-Za-z]+)?)/g
    , (_m, space, link) ->
      "#{space}<a href=\"/p/#{link.replace '/', '#'}\">##{link}</a>"
    , (_m, space, link) ->
      "#{space}[##{link}](/p/#{link.replace '/', '#'})"
    ]

  IMG_PREVIEW_FORMATTER:
    [/<a href="([^"]+\.(jpg|jpeg|gif|png))">([^<]+)<\/a>/g
    , (_m, link, ext, alt) ->
      "<span class=\"preview#{if ext == 'gif' then ' preview-gif' else ''}\"><a href=\"#{link}\"><img src=\"#{viewHelpers.getThumbUrl(link)}\" alt=\"#{alt}\"></a></span>"
    ]

  YT_PREVIEW_FORMATTER:
    [/<a href="https?:\/\/(?:|www\.)youtu(?:be.com\/watch\?v=|\.be\/)([-\w]{11})(?:[^"]*)">([^<]+)<\/a>/g
    , (_m, id, link) ->
      "<span class=\"preview youtube\"><a href=\"#{link}\"><img src=\"https://img.youtube.com/vi/#{id}/0.jpg\"></a></span>"
    ]

  markdown: (raw) ->
    ###Markdown with some additional BnW-specific rules.###

    FIX_LINE_ENDINGS =
      [/\r/g, ""]

    # Do the wakabic blockquotes
    WAKABAMARK_BLOCKQUOTE =
      [/(^|\n)(>.+)(?=\n[^>])/g, "$1$2\n"]

    format = (rawb) =>
      ###Apply BnW additional formatters to the block of raw text.###
      rawb = rawb.replace FIX_LINE_ENDINGS[0], FIX_LINE_ENDINGS[1]
      rawb = rawb.replace WAKABAMARK_BLOCKQUOTE[0], WAKABAMARK_BLOCKQUOTE[1]
      rawb = rawb.replace @USER_LINK_FORMATTER[0], @USER_LINK_FORMATTER[2]
      rawb = rawb.replace @POST_LINK_FORMATTER[0], @POST_LINK_FORMATTER[2]

    # Walk through raw input text and apply bnw formatters only
    # for non-code blocks.
    result = []
    while raw.length
      # Work with non-code
      i = raw.indexOf "`"
      if i == -1
        result.push format raw
        break
      result.push format raw[...i]
      raw = raw[i..]

      # Work with code blocks
      # Multi-line or inline code
      searchFor = if raw[...3] == "```" then "```" else "`"
      i = raw.indexOf searchFor, searchFor.length
      if i == -1
        result.push raw
        break
      end = i + searchFor.length
      result.push raw[...end]
      raw = raw[end..]
    stage2 = result.join ""

    # At last apply marked renderer and hope it do well
    html = marked stage2,
      pedantic: false,
      gfm: true,
      sanitize: true,  # Escaping! Don't touch.
      tables: false,
      breaks: true,
      smartLists: false,
      langPrefix: 'language-'

    # Image's previews
    html.replace @IMG_PREVIEW_FORMATTER[0], @IMG_PREVIEW_FORMATTER[1]

    # Youtube previews
    html.replace @YT_PREVIEW_FORMATTER[0], @YT_PREVIEW_FORMATTER[1]

  moinmoin: (raw) ->
    ###
    Simple moinmoin-like text format.
    Use simple regexp parsers for process. Reference:
    <https://github.com/stiletto/bnw/blob/master/bnw_web/linkify.py>
    ###

    codeFormatter =
      [/{{{(?:#!(\w+)\s|\n)?([^]+?)(?:\n)?}}}\n?/, (_m, lang, code) ->
        klass = if lang then " class=\"language-#{lang}\"" else ""
        "<pre><code#{klass}>#{code}</code></pre>"
      ]

    textFormatters = [
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
      @USER_LINK_FORMATTER
      @POST_LINK_FORMATTER
      @IMG_PREVIEW_FORMATTER
      @YT_PREVIEW_FORMATTER
      # Fix newlines
      [/\n/g, -> "<br />"]
    ]

    # Very-very important line, don't ever try to touch it
    text = @escape2 raw

    # Format block of text with formatters
    format = (block) ->
      _(textFormatters).reduce (tmpText, [regexp, handler]) ->
        tmpText.replace regexp, handler
      , block

    # XXX: Special case for code block. It's better to use normal
    # parser but this formatting style will be deprecated soon so
    # we don't waste our time on it.
    # Go throught text and try to match code blocks. On each code
    # block do code formatter replace. On others do text formatting.
    result = []
    while text.length
      match = text.match codeFormatter[0]
      if match
        result.push format text[...match.index]
        result.push codeFormatter[1] match...
        text = text[match.index + match[0].length..]
      else
        result.push format text
        break
    result.join ""
