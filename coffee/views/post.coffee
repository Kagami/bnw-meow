define [
  "views/base/refresh_date"
  "lib/utils"
  "templates/post"
], (RefreshDateView, utils, template) ->
  "use strict"

  class PostView extends RefreshDateView

    template: template
    autoRender: true
    events:
      "click .post-recommendations-info": "recommend"

    initialize: (options) ->
      super options
      @singlePost = options?.singlePost

    templateData: ->
      isRecommended: @isRecommended()
      singlePost: @singlePost

    isRecommended: ->
      return unless utils.isLogged()
      utils.getUser() in @model.get("recommendations")

    recommend: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      data = message: @model.get "id"
      data.unrecommend = true if @isRecommended()
      utils.post "recommend", data, true
