define [
  "jquery"
  "cookie"
  "underscore"
  "chaplin"
  'lib/view_helpers'
], ($, cookie, _, Chaplin, viewHelpers) ->
  "use strict"

  utils = Chaplin.utils.beget Chaplin.utils

  _(utils).extend viewHelpers,

    apiCall: (func, data = {}, method = "GET") ->
      # TODO: Notification about unsuccessful request
      deferred = $.Deferred()
      promise = deferred.promise()

      data.login = utils.getLoginKey() if utils.isLogged()
      jqxhr = $.ajax
        url: @bnwUrl "/api/#{func}"
        type: method
        data: data
        # This should actually be auto-detectable (backend do return
        # correct Content-Type header) but jQuery sucks.
        dataType: "json"
      jqxhr.done (data) =>
        deferred[if data.ok then "resolve" else "reject"] data
      jqxhr.fail ->
        # TODO: Error info
        deferred.reject()
      promise

    gotoUrl: (url, force = true) ->
      Chaplin.mediator.publish "!router:route", url, forceStartup: force

    # Get and set login info via cookies bakend.
    # Note that we reread login key from cookies on the each request.

    setCookie: (key, value) ->
      $.cookie key, value, expires: 365, path: "/"

    getLoginKey: ->
      $.cookie "login"

    setLoginKey: (loginKey) ->
      @setCookie "login", loginKey

    setUser: (user) ->
      @setCookie "user", user

    clearAuth: ->
      $.removeCookie "login"
      $.removeCookie "user"

    # Global vars emulation. Doesn't seems like a perfect solution
    # but it works.

    getGlobal: (key) ->
      window.MEOW_GLOBALS?[key]

    setGlobal: (key, value) ->
      window.MEOW_GLOBALS ?= {}
      window.MEOW_GLOBALS[key] = value
