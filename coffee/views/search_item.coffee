define [
  "views/base/refresh_date"
  "templates/post"
  "templates/comment"
], (RefreshDateView, postTemplate, commentTemplate) ->
  "use strict"

  class SearchItemView extends RefreshDateView

    templateData:
      search: true

    getTemplateFunction: ->
      if @model.get("type") is "message"
        postTemplate
      else
        commentTemplate
