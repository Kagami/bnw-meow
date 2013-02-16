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
      "click .post-comments-info": "subscribe"
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

    subscribe: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      # XXX: Currently there is no ability to know if we've
      # subscribed on the post or not.
      data = message: @model.get "id"
      utils.post "subscriptions/add", data, true

    recommend: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      data = message: @model.get "id"
      data.unrecommend = true if @isRecommended()
      utils.post "recommend", data, true
