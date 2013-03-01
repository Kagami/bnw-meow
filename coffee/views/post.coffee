define [
  "jquery"
  "highlight"
  "views/base/refresh_date"
  "lib/utils"
  "templates/post"
], ($, hljs, RefreshDateView, utils, template) ->
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
      @templateData = pageUser: options.pageUser
      # Subscribe to websocket events
      @subscribeEvent "!ws:new_message:#{@model.get 'id'}", @onAdd
      @subscribeEvent "!ws:del_message:#{@model.get 'id'}", @onDel
      @subscribeEvent "!ws:upd_comments_count:#{@model.get 'id'}", @updComments
      @subscribeEvent "!ws:upd_recommendations_count:#{@model.get 'id'}",
        @updRecommendations

    afterRender: ->
      super
      @firstDiv = @$el.children(0)
      @$("pre code").each (i, e) ->
        hljs.highlightBlock e

    templateData: ->
      singlePost: @singlePost

    subscribe: (e) ->
      e.preventDefault()
      return unless utils.isLogged()

      data = message: @model.get "id"
      subscribed = not @model.get "subscribed"
      @model.set "subscribed", subscribed
      func = if subscribed then "subscriptions/add" else "subscriptions/del"
      utils.post func, data, true

      if utils.isLogged()
        title = if subscribed then "Отписаться" else "Подписаться"
        i = @$(".post-comments-info").attr("title", title).children("i")
        if subscribed
          i.addClass("icon-marked")
        else
          i.removeClass("icon-marked")

    recommend: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      data = message: @model.get "id"
      data.unrecommend = true if @model.getAttributes().recommended
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
      @model.set "recommendations", data.recommendations
      if @singlePost
        # It's ok to rerender full post since .post-footer2 must be
        # completely rerendered.
        @render()
        return

      # Actually we could rerender on any small websocket event but
      # we do some micro-optimizations.
      # TODO: Or we may fuck it up.
      @$(".post-recommendations-count").text(data.num)
      attrs = @model.getAttributes()
      i = @$(".post-recommendations-info")\
          .attr("title", attrs.recommendationsTitle).children("i")
      if utils.isLogged()
        if attrs.recommended
          i.addClass("icon-marked")
        else
          i.removeClass("icon-marked")
