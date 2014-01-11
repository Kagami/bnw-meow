define [
  "jquery"
  "underscore"
  "config"
], ($, _, config) ->
  "use strict"

  viewHelpers =

    getBnwUrl: (path) ->
      "#{config.BNW_API_PROTOCOL}://#{config.BNW_API_HOST}#{path}"

    isLogged: ->
      $.cookie("login")?

    getUser: ->
      $.cookie "user"

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
