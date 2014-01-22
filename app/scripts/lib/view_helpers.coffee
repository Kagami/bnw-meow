_ = require "underscore"
moment = require "moment"
config = require "config"

module.exports =
  getBnwUrl: (path) ->
    "#{config.BNW_API_PROTOCOL}://#{config.BNW_API_HOST}#{path}"

  getAvatarUrl: (username) ->
    _.template(config.IDENTICON_URL, {username})

  getThumbUrl: (imageUrl) ->
    imageUrl = encodeURIComponent imageUrl
    _.template(config.THUMBIFY_URL, {imageUrl})

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

  # Get and set login info via local storage bakend.

  LOGIN_KEY_NAME: "bnw-meow_login-key"
  USER_KEY_NAME: "bnw-meow_user"

  getLoginKey: ->
    localStorage.getItem @LOGIN_KEY_NAME

  setLoginKey: (loginKey) ->
    localStorage.setItem @LOGIN_KEY_NAME, loginKey

  clearLoginKey: ->
    localStorage.removeItem @LOGIN_KEY_NAME

  isLogged: ->
    @getLoginKey()?

  getUser: ->
    localStorage.getItem @USER_KEY_NAME

  setUser: (user) ->
    localStorage.setItem @USER_KEY_NAME, user

  clearUser: ->
    localStorage.removeItem @USER_KEY_NAME

  clearAuth: ->
    @clearLoginKey()
    @clearUser()
