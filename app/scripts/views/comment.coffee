$ = require "jquery"
hljs = require "highlight"
RefreshDateView = require "views/base/refresh_date"
utils = require "lib/utils"
template = require "templates/comment"

module.exports = class CommentView extends RefreshDateView
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
    @firstDiv = @$el.children(0)
    # At first we must undelegate current events on current $el
    @undelegateEvents()
    # Listen events only on first div (because of nesting)
    @$el = @firstDiv
    @delegateEvents()
    @$("pre code").each (i, e) ->
      hljs.highlightBlock e

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
    goOut = =>
      setTimeout =>
        @firstDiv.removeClass("comment-added")
      , 3000
    setAppear = =>
      @firstDiv.appear(goOut, one: true, accY: -50)
    if document.hasFocus()
      setAppear()
    else
      $(window).one("focus", setAppear)
    attributes = @model.getAttributes()
    utils.addReplyLink(attributes.commentId,attributes.replyCommentId)

  onDel: ->
    # Just delete comment div from the DOM. It still be stored
    # in the model.
    @firstDiv.removeClass("comment-added").addClass("comment-deleted")
    hide = =>
      @firstDiv.fadeOut("slow", => @dispose())
    setTimeout hide, 3000
    attributes = @model.getAttributes()
    utils.removeReplyLink(attributes.commentId,attributes.replyCommentId)

  selectComment: (e) ->
    e.preventDefault()
    id = @model.getAttributes().replyCommentId
    window.location.hash = id
    utils.scrollToAnchor "##{id}"
