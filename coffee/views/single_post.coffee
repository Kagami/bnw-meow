define [
  "jquery"
  "chaplin"
  "models/comment"
  "views/base/view"
  "views/post"
  "views/comments"
  "views/comment"
  "views/dialog_delete"
  "views/header"
  "lib/utils"
  "templates/single_post"
], ($, Chaplin, Comment, View, PostView, CommentsView, CommentView,
    DialogDeleteView, HeaderView, utils, template) ->
  "use strict"

  class SinglePostView extends View

    container: "#main"
    template: template
    autoRender: true
    events:
      "click #comment-form-submit": "comment"
      "click #comment-form-reset": "resetCommentForm"
      "keypress #comment-form-text": "keypress"
      "click .post-id": "moveCommentForm"

    afterInitialize: ->
      super
      d = @model.fetch()
      d.fail =>
        # TODO: Refactor using View#fetchWithPreloader
        @$(".preloader").remove()
      d.done =>
        @subscribeEvent "!ws:new_comment", @onNewComment
        @initWebSocket()

        @render fetched: true

        text = @model.get "text"
        @publishEvent "!adjustTitle", utils.truncate text

        dialog = new DialogDeleteView singlePost: true
        @subview "dialog", dialog

        post = new PostView
          model: @model
          el: "#single-post"
          singlePost: true
          dialog: dialog
        post.render()
        @subview "post", post

        comments = new CommentsView collection: @model.replies, dialog: dialog
        @subview "comments", comments

        breadcrumbs = [
          ["/u/#{@model.get 'user'}", "user", @model.get "user"]
          ["/p/#{@model.get 'id'}", "comment-alt", @model.get "id"]
        ]
        HeaderView::updateBreadcrumbs breadcrumbs, true

        utils.scrollToAnchor()

    comment: ->
      return unless utils.isLogged()

      textarea = $("#comment-form-text")
      replyTo = $("#comment-form-reply-to")
      messageId = @model.get "id"
      messageId += "/" + replyTo.val() if replyTo.val().length
      submit = $("#comment-form-submit").prop("disabled", true)
      i = submit.children("i").toggleClass("icon-refresh icon-spin")
      clear = $("#comment-form-clear").prop("disabled", true)

      d = utils.post "comment", message: messageId, text: textarea.val()
      d.always ->
        submit.prop("disabled", false)
        i.toggleClass("icon-refresh icon-spin")
        clear.prop("disabled", false)
      d.done =>
        textarea.val("")
        @resetCommentForm()

    keypress: (e) ->
      if e.ctrlKey and (e.keyCode == 13 or e.keyCode == 10)
        unless $("#comment-form-submit").prop("disabled")
          @comment()

    resetCommentForm: ->
      $("#comments").after($("#comment-form"))
      $("#comment-form-text").val("")
      $("#comment-form-reply-to").val("")

    moveCommentForm: (e) ->
      # Run in the context of post subview (because of $el).
      CommentView::moveCommentForm.call @subview("post"), e, ""

    onNewComment: (commentData) ->
      comment = new Comment commentData, postUser: @model.get "user"
      index = $("#comments").children().length
      @model.replies.add comment, {index}
