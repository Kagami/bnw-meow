define [
  "underscore"
  "views/base/view"
  "models/user_info"
  "lib/utils"
  "templates/user_info"
], (_, View, UserInfo, utils, template) ->
  "use strict"

  class UserInfoView extends View

    el: "#user-info"
    template: template
    events:
      "click .user-info-show-more": "showMore"
      "click .user-info-subscribe": "subscribe"
      "click .user-info-blacklist": "blacklist"

    initialize: (options) ->
      super options
      @model = new UserInfo {}, user: options.user
      @show = options.show
      @fetchWithPreloader()?.done =>
        @render()

    afterRender: ->
      super
      @$(".#{@show}").addClass("active")

    subscribe: ->
      return unless utils.isLogged()
      loggedUser = utils.getUser()
      subscribed = not @model.getAttributes().subscribed
      subscribersAll = _(@model.get "subscribers_all").clone()
      @model.set "subscribers_all", if subscribed
        subscribersAll.push loggedUser
        subscribersAll
      else
        _(subscribersAll).without loggedUser
      func = if subscribed then "subscriptions/add" else "subscriptions/del"
      utils.post(func, {user: @model.get "user"}, true).done =>
        # We do full re-render but since html may change a lot
        # it's ok.
        @render()

    blacklist: ->
      return unless utils.isLogged()
      # FIXME: Determine whether logged user has already
      # blacklisted this user.
      utils.post "blacklist", {user: @model.get "user"}, true

    showMore: (e) ->
      e.preventDefault()
      @$(".user-info-additional").toggle()
