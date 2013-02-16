define [
  "jquery"
  "chaplin"
  "views/base/view"
  "views/post"
  "views/comments"
  "lib/utils"
  "templates/single_post"
], ($, Chaplin, View, PostView, CommentsView, utils, template) ->
  "use strict"

  class SinglePostView extends View

    container: "#main"
    template: template
    autoRender: true

    afterInitialize: ->
      super
      d = @model.fetch()
      d.always =>
        @$(".preloader").remove()
      d.done =>
        text = @model.get "text"
        Chaplin.mediator.publish "!adjustTitle", utils.formatPostTitle text

        post = new PostView model: @model, el: "#single-post", singlePost: true
        @subview "post", post

        comments = new CommentsView collection: @model.replies
        @subview "comments", comments

        # Fix position on the page
        commentDiv = @$(window.location.hash)
        if commentDiv.length
          $("html, body").scrollTop(commentDiv.offset().top - 41)
