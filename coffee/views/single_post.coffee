define [
  "jquery"
  "chaplin"
  "views/base/view"
  "views/post"
  "views/comments"
  "views/dialog_delete"
  "lib/utils"
  "templates/single_post"
], ($, Chaplin, View, PostView, CommentsView, DialogDeleteView, utils,
    template) ->
  "use strict"

  class SinglePostView extends View

    container: "#main"
    template: template
    autoRender: true
    events:
      "click #comment-form-submit": "comment"
      "keypress #comment-form-text": "keypress"

    afterInitialize: ->
      super
      d = @model.fetch()
      d.fail =>
        @$(".preloader").remove()
      d.done =>
        @render fetched: true

        text = @model.get "text"
        Chaplin.mediator.publish "!adjustTitle", utils.formatPostTitle text

        dialog = new DialogDeleteView singlePost: true
        @subview "dialog", dialog

        post = new PostView
          model: @model
          el: "#single-post"
          singlePost: true
          dialog: dialog
        @subview "post", post

        comments = new CommentsView collection: @model.replies, dialog: dialog
        @subview "comments", comments

        # Fix position on the page
        commentDiv = @$(window.location.hash)
        if commentDiv.length
          $("html, body").scrollTop(commentDiv.offset().top - 41)

    comment: (e) ->
      e.preventDefault()
      return unless utils.isLogged()

      textarea = @$("#comment-form-text")
      replyTo = @$("#comment-form-reply-to")
      messageId = @model.get "id"
      messageId += "/" + replyTo.val() if replyTo.val().length
      submit = @$("#comment-form-submit").prop("disabled", true)
      i = submit.children("i").toggleClass("icon-refresh icon-spin")
      clear = @$("#comment-form-clear").prop("disabled", true)

      d = utils.post "comment", message: messageId, text: textarea.val()
      d.always ->
        submit.prop("disabled", false)
        i.toggleClass("icon-refresh icon-spin")
        clear.prop("disabled", false)
      d.done ->
        textarea.val("")
        replyTo.val("")

    keypress: (e) ->
      if e.ctrlKey and (e.keyCode == 13 or e.keyCode == 10)
        unless @$("#comment-form-submit").prop("disabled")
          @comment e
