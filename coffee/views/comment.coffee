define [
  "views/base/refresh_date"
  "lib/utils"
  "templates/comment"
], (RefreshDateView, utils, template) ->
  "use strict"

  class CommentView extends RefreshDateView

    template: template
    events:
      "click .comment-delete": "markForDelete"

    initialize: (options) ->
      super options
      @dialog = options.dialog

    templateData: ->
      canDelete: @canDelete()

    canDelete: ->
      return unless utils.isLogged()
      utils.getUser() in [@model.get("user"), @model.postUser]

    markForDelete: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      a = $(e.currentTarget)
      a.toggleClass("comment-delete-marked")
      @dialog.updateMarked()
