$ = require "jquery"
Chaplin = require "chaplin"
DialogView = require "views/base/dialog"
utils = require "lib/utils"
template = require "templates/dialog_login"

module.exports = class DialogNewPostView extends DialogView
  container: "body"
  template: template
  events:
    "submit #login-form": "submit"

  afterRender: ->
    super
    @$("[data-toggle='tab']").on "show shown", (e) ->
      e.stopPropagation()
    @modal.on "show", ->
      $("#login-form-login").val("")
      $("#login-form-password").val("")
      $("#login-form-loginkey").val("")
      $("#login-form-tabs [href='#by-pass']").tab("show")
    @modal.on "shown", ->
      $("#login-form-login").focus()

  submit: (e) ->
    e.preventDefault()
    submit = $("#login-form-submit").prop("disabled", true)
    cancel = $("#login-form-cancel").prop("disabled", true)
    i = submit.children("i").toggleClass("icon-refresh icon-spin")

    d = if $("#by-pass").is(":visible")
      user = $("#login-form-login").val()
      password = $("#login-form-password").val()
      d = utils.post "passlogin", {user, password}
      d.done (data) ->
        # Get key from "description"? Fuckin' API ugliness.
        utils.setLoginKey data.desc
        utils.setUser user
    else
      # FIXME: Write Everything Twice. The (almost) same code
      # are in login controller.
      loginKey = $("#login-form-loginkey").val()
      utils.setLoginKey loginKey
      d = utils.get "whoami"
      d.done (data) ->
        utils.setUser data.user
      d.fail ->
        utils.clearAuth()

    d.always ->
      submit.prop("disabled", false)
      cancel.prop("disabled", false)
      i.toggleClass("icon-refresh icon-spin")

    d.done =>
      @hide()
      @publishEvent "!view:header:render"
      utils.gotoUrl "/"
