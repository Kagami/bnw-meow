define [
  "jquery"
  "views/base/refresh_date"
  "lib/utils"
  "templates/post"
], ($, RefreshDateView, utils, template) ->
  "use strict"

  class PostView extends RefreshDateView

    template: template
    autoRender: true
    events:
      "click .post-comments-info": "subscribe"
      "click .post-recommendations-info": "recommend"
      "click .post-delete": "toggleMark"

    initialize: (options) ->
      super options
      @dialog = options.dialog
      @singlePost = options?.singlePost
      # Subscribe to websocket events
      @subscribeEvent "!ws:new_message:#{@model.get 'id'}", @onAdd
      @subscribeEvent "!ws:del_message:#{@model.get 'id'}", @onDel
      @subscribeEvent "!ws:upd_comments_count:#{@model.get 'id'}", @updComments
      @subscribeEvent "!ws:upd_recommendations_count:#{@model.get 'id'}",
        @updRecommendations

    afterRender: ->
      super
      @firstDiv = @$el.children(0)

    templateData: ->
      isRecommended: @isRecommended()
      canDelete: @canDelete()
      singlePost: @singlePost

    isRecommended: ->
      return unless utils.isLogged()
      utils.getUser() in @model.get("recommendations")

    canDelete: ->
      return unless utils.isLogged()
      utils.getUser() == @model.get "user"

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

    toggleMark: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      @dialog.toggleMark this

    onAdd: ->
      @firstDiv.addClass("post-added")
      @firstDiv.mouseover =>
        @firstDiv.removeClass("post-added").off("mouseover")

    onDel: ->
      # Just delete post div from the DOM. It still be stored
      # in the model.
      @firstDiv.removeClass("post-added").addClass("post-deleted")
      hide = =>
        @firstDiv.fadeOut("slow", => @dispose())
      setTimeout hide, 3000

    updComments: (data) ->
      @$(".post-comments-count").text(data.num)

    updRecommendations: (data) ->
      @$(".post-recommendations-count").text(data.num)
