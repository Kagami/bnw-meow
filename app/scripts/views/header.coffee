$ = require "jquery"
Tinycon = require "tinycon"
Chaplin = require "chaplin"
View = require "views/base/view"
DialogNewPostView = require "views/dialog_new_post"
DialogLoginView = require "views/dialog_login"
RefreshDateView = require "views/base/refresh_date"
ViewHelpers = require "lib/view_helpers"
utils = require "lib/utils"
template = require "templates/header"

module.exports = class HeaderView extends View
  el: "#menu"
  template: template
  autoRender: true
  events:
    "click #common-menu a": "navigate"
    "click .show-new-post": "showNewPost"
    "click .logout": "logout"
    "click .anonymous-mode": "anonymousMode"
    "click .to-the-top": "toTheTop"
    "click .show-login-dialog": "showLoginDialog"
    "submit .search-form": "search"
  templateData:
    breadcrumbs: []

  initialize: ->
    super
    #: How many events wait for the user attention
    @eventsCounter = 0
    @subscribeEvent "!ws:new_message", @incCounter
    @subscribeEvent "!ws:new_comment", @incCounter
    $(window).focus => @resetCounter()

    @subscribeEvent "!view:header:render", @render
    @subscribeEvent "!router:changeURL", @updateActiveItem
    @subscribeEvent "!breadcrumbs:update", (breadcrumbs) ->
      @templateData.breadcrumbs = breadcrumbs
      @render()

    # Update date in all posts/comments on the page
    setInterval RefreshDateView::tick, 60000

    # Check anonymous status every 500ms and indicate it with icon
    setInterval @RefreshAnonymousStatus, 500

    newPostView = new DialogNewPostView()
    @subview "dialog-new-post", newPostView

    loginView = new DialogLoginView()
    @subview "dialog-login", loginView

    $(window).scroll =>
      if $(window).scrollTop() > 300
        @$(".to-the-top").show()
      else
        @$(".to-the-top").hide()

  afterRender: ->
    super

  # Reload controller even if url was not changed
  navigate: (e) ->
    url = $(e.currentTarget).attr("href")
    utils.gotoUrl url
    # For some reason jQuery's event.preventDefault() doesn't work here
    false

  showNewPost: (e) ->
    e.preventDefault()
    return unless utils.isLogged()
    @subview("dialog-new-post").show()

  logout: (e) ->
    e.preventDefault()
    utils.clearAuth()
    @render()
    utils.gotoUrl "/"

  incCounter: ->
    @eventsCounter++
    @updateCounter()

  resetCounter: ->
    @eventsCounter = 0
    @updateCounter true

  updateCounter: (force = false) ->
    # XXX: Focus activity determination may not working in Chrome
    # and Opera. See browser compatibility section at:
    # https://developer.mozilla.org/en-US/docs/DOM/document.hasFocus
    if force or not document.hasFocus()
      counter = if @eventsCounter > 99 then 99 else @eventsCounter
      Tinycon.setBubble counter

  updateActiveItem: (url = window.location.pathname) ->
    ###Update active (current) element of the menu items.###
    # Note that we can't use header's own properties here
    url = "/#{decodeURIComponent url}" if url[0] != "/"
    $("#common-menu>li").removeClass("active")
    a = $("#common-menu a[href='#{url}']")
    if a.length
      a.parent().addClass("active")

  updateBreadcrumbs: (breadcrumbs, lateUpdate = false) ->
    ###
    Send signal to header view class instance for request to update
    breadcrumbs list.

    :param lateUpdate: default false. Useful when we want to update
                       breadcrumbs _after_ the signal about changing
                       url have been sent.
    ###
    @publishEvent "!breadcrumbs:update", breadcrumbs
    @updateActiveItem() if lateUpdate

  toTheTop: ->
    $("html, body").animate(scrollTop: 0, "fast")

  showLoginDialog: (e) ->
    e.preventDefault()
    return if utils.isLogged()
    @subview("dialog-login").show()

  anonymousMode: (e) ->
    e.preventDefault()
    ViewHelpers.toggleAnonymousStatus()

  RefreshAnonymousStatus: ->
    anonymous = ViewHelpers.getAnonymousModeStatus()
    icon = @$(".icon-eye-close")

    if anonymous
      icon.addClass "active"
    else
      icon.removeClass "active"

  search: (e) ->
    e.preventDefault()
    query = utils.encode @$(".search-form-query").val()
    utils.gotoUrl "/search/#{query}"
