define [
  "chaplin"
  "lib/utils"
], (Chaplin, utils) ->
  "use strict"

  class LoginController extends Chaplin.Controller

    login: ->
      # Chaplin can't even get query parameters from urls
      loginKey = window.location.search.split("=")[1]
      return if not loginKey? or not loginKey.length

      utils.setLoginKey loginKey
      d = utils.get "whoami"
      d.done (data) ->
        utils.setUser data.user
      d.fail ->
        utils.clearAuth()
      d.always ->
        Chaplin.mediator.publish "!view:menu:render"
        utils.gotoUrl "/"
