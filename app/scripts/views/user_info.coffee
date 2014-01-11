_ = require "underscore"
View = require "views/base/view"
UserInfo = require "models/user_info"
utils = require "lib/utils"
template = require "templates/user_info"

module.exports = class UserInfoView extends View
  el: "#user-info"
  template: template
  events:
    "click .user-info-show-more": "showMore"
    "click .user-info-toggle": "toggleInfo"
    "click .user-info-subscribe": "subscribe"
    "click .user-info-blacklist": "blacklist"

  initialize: (options) ->
    super options
    # FIXME: Seems like this model will not be disposed
    @model = new UserInfo {}, user: options.user
    @show = options.show
    @fetchWithPreloader()?.done =>
      @render()

  ITEMS_LENGTH_THRESHOLD: 10

  afterRender: ->
    super
    # Highlight all/message/recommendations list item
    @$(".#{@show}").addClass("active")
    # Fix visibility of short info lists
    if @model.get("subscriptions_all").length < @ITEMS_LENGTH_THRESHOLD
      @$(".user-info-subscriptions").children("div").show()
    if @model.get("subscribers_all").length < @ITEMS_LENGTH_THRESHOLD
      @$(".user-info-subscribers").children("div").show()

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

  toggleInfo: (e) ->
    e.preventDefault()
    $(e.currentTarget).closest("p").next().toggle()
