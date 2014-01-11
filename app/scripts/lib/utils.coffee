$ = require "jquery"
_ = require "underscore"
moment = require "moment"
Chaplin = require "chaplin"
viewHelpers = require "lib/view_helpers"
notification = require "templates/notification"

utils = Chaplin.utils.beget Chaplin.utils

module.exports = _(utils).extend viewHelpers,
  apiCall: (func, data = {}, method = "GET", options = {}) ->
    deferred = $.Deferred()
    promise = deferred.promise()

    data.login = utils.getLoginKey() if utils.isLogged()
    jqxhr = $.ajax
      url: @getBnwUrl "/api/#{func}"
      type: method
      data: data
      # This should actually be auto-detectable (backend do return
      # correct Content-Type header) but jQuery sucks.
      dataType: "json"
    jqxhr.done (data) =>
      if data.ok
        @showAlert data.desc, "info" if options.verbose
        deferred.resolve data
      # Must be 4xx HTTP code actually, but @stiletto fucked it up.
      else
        @showAlert data.desc
        deferred.reject data
    jqxhr.fail (err) =>
      text = "Ошибка AJAX: #{err.status} #{err.statusText}"
      @showAlert text
      deferred.reject()
    promise

  showAlert: (text, type = "error", autoHide = true) ->
    alert = $(@renderTemplate(notification, text: text, type: type))
    $("#notifications").append(alert)
    if autoHide
      hide = ->
        alert.fadeOut("slow", -> alert.remove())
      setTimeout hide, 5000

  # Helpers around apiCall

  get: (func, data = {}, verbose = false) ->
    @apiCall func, data, "GET", {verbose}

  post: (func, data = {}, verbose = false) ->
    @apiCall func, data, "POST", {verbose}

  gotoUrl: (url, force = true) ->
    Chaplin.mediator.publish "!router:route", url, forceStartup: force

  # Get and set login info via cookies bakend.
  # Note that we reread login key and user login info from cookies
  # on the each action requires auth. It _could_ be inefficient but
  # I don't think so.

  setCookie: (key, value) ->
    $.cookie key, value, expires: 365, path: "/"

  removeCookie: (key) ->
    $.removeCookie key, path: "/"

  getLoginKey: ->
    $.cookie "login"

  setLoginKey: (loginKey) ->
    @setCookie "login", loginKey

  setUser: (user) ->
    @setCookie "user", user

  clearAuth: ->
    @removeCookie "login"
    @removeCookie "user"

  # Misc

  pluralForm: (n, [p1, p2, p5], withNumber = false) ->
    _pluralForm = ->
      if 10 < n < 15
        return p5
      n = n % 10
      if n == 1
        p1
      else if 1 < n < 5
        p2
      else
        p5

    if withNumber
      "#{n} #{_pluralForm()}"
    else
      _pluralForm()

  now: ->
    ###Return current formatted time.###
    moment().format("HH:mm:ss")

  scrollToAnchor: (id = window.location.hash) ->
    el = $(id)
    if el.length
      $(".selected").removeClass("selected")
      el.addClass("selected")
      # 41px — compensate for navbar
      $("html, body").scrollTop(el.offset().top - 41)

  encode: (text) ->
    encodeURIComponent(text).replace /%20/g, "+"

  decode: (text) ->
    decodeURIComponent(text).replace /\+/g, " "

  SHORT_POST_LENGTH: 500
  truncatePost: (text, format, id) ->
    if format isnt "moinmoin"
      # XXX: Of course it is much better to shrink post based on
      # it's rendered size but jquery.dotdotdot is so horrible slow.
      # (About 38ms for single middle-sized div. What the fuck?)
      if text.length > @SHORT_POST_LENGTH
        text = text[...@SHORT_POST_LENGTH]
        id = id.replace "/", "#"
        text += " […](/p/#{id} \"Читать дальше\")"
    text
