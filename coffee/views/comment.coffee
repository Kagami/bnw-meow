define [
  "jquery"
  "views/base/refresh_date"
  "lib/utils"
  "templates/comment"
], ($, RefreshDateView, utils, template) ->
  "use strict"

  class CommentView extends RefreshDateView

    template: template
    events:
      "click .comment-delete": "toggleMark"
      "click .comment-id": "moveCommentForm"

    initialize: (options) ->
      super options
      @dialog = options.dialog

    templateData: ->
      canDelete: @canDelete()

    canDelete: ->
      return unless utils.isLogged()
      utils.getUser() in [@model.get("user"), @model.postUser]

    toggleMark: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      @dialog.toggleMark this

    moveCommentForm: (e, id = undefined) ->
      return unless utils.isLogged()
      e.preventDefault()
      form = $("#comment-form").css("margin-left", "30px")
      @$el.after(form)
      id ?= @model.getAttributes().commentId
      $("#comment-form-reply-to").val(id)
      $("#comment-form-text").focus()
