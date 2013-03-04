define [
  "jquery"
  "views/base/refresh_date"
  "lib/utils"
  "templates/comment"
], ($, RefreshDateView, utils, template) ->
  "use strict"

  class CommentView extends RefreshDateView

    template: template
    className: "comment-wrapper"
    events:
      "click .comment-delete": "toggleMark"
      "click .comment-id": "moveCommentForm"
      "click .comment-reply-to": "selectComment"

    initialize: (options) ->
      super options
      @dialog = options.dialog
      # Subscribe to websocket events
      @subscribeEvent "!ws:new_comment:#{@model.get 'id'}", @onAdd
      @subscribeEvent "!ws:del_comment:#{@model.get 'id'}", @onDel

    afterRender: ->
      super
      # Listen events only on first div (because of nesting)
      @firstDiv = @$el.children(0)
      # At first we must undelegate current events on current $el
      @undelegateEvents()
      @$el = @firstDiv
      @delegateEvents()

    toggleMark: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      @dialog.toggleMark this

    moveCommentForm: (e, id = undefined) ->
      return unless utils.isLogged()
      e.preventDefault()
      @firstDiv.after($("#comment-form"))
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

    selectComment: (e) ->
      e.preventDefault()
      id = @model.getAttributes().replyCommentId
      window.location.hash = id
      utils.scrollToAnchor "##{id}"
