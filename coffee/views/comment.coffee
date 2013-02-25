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
      # Subscribe to websocket events
      @subscribeEvent "!ws:new_comment:#{@model.get 'id'}", @onAdd
      @subscribeEvent "!ws:del_comment:#{@model.get 'id'}", @onDel

    afterRender: ->
      super
      @firstDiv = @$el.children(0)

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

    onAdd: ->
      @firstDiv.addClass("comment-added")
      @firstDiv.mouseover =>
        @firstDiv.removeClass("comment-added").off("mouseover")

    onDel: ->
      # Just delete comment div from the DOM. It still be stored
      # in the model.
      @firstDiv.removeClass("comment-added").addClass("comment-deleted")
      hide = =>
        @firstDiv.fadeOut("slow", => @dispose())
      setTimeout hide, 3000
