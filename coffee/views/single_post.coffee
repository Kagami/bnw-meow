define [
  "jquery"
  "chaplin"
  "views/base/refresh_date"
  "views/comments"
  "lib/utils"
  "templates/single_post"
  "templates/post"
], ($, Chaplin, RefreshDateView, CommentsView, utils, template,
    postTemplate) ->
  "use strict"

  class SinglePostView extends RefreshDateView

    container: "#main"
    template: template
    autoRender: true
    templateData:
      postTemplate: postTemplate
      singlePost: true

    afterInitialize: ->
      super
      d = @model.fetch()
      d.fail =>
        @$(".preloader").remove()
      d.done =>
        text = @model.get "text"
        Chaplin.mediator.publish "!adjustTitle", utils.formatPostTitle text

        @render fetched: true

        comments = new CommentsView collection: @model.replies
        @subview "comments", comments
        comments.render()

        # Fix position on the page
        commentDiv = @$(window.location.hash)
        if commentDiv.length
          $("html, body").scrollTop(commentDiv.offset().top - 41)
