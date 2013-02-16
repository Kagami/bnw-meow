define [
  "views/base/refresh_date"
  "lib/utils"
  "templates/post"
], (RefreshDateView, utils, template) ->
  "use strict"

  class PostView extends RefreshDateView

    template: template
    events:
      "click .post-recommendations-info": "recommend"

    templateData: ->
      isRecommended: @isRecommended()

    isRecommended: ->
      return unless utils.isLogged()
      utils.getUser() in @model.get("recommendations")

    recommend: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      data = message: @model.get "id"
      data.unrecommend = true if @isRecommended()
      utils.post "recommend", data, true
