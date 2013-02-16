define [
  "views/base/refresh_date"
  "lib/utils"
  "templates/comment"
], (RefreshDateView, utils, template) ->
  "use strict"

  class CommentView extends RefreshDateView

    template: template
    events:
      "click .comment-delete": "toggleMark"

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
