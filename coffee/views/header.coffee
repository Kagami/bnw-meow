define [
  "jquery"
  "tinycon"
  "chaplin"
  "views/base/view"
  "views/dialog_new_post"
  "lib/utils"
  "templates/header"
], ($, Tinycon, Chaplin, View, DialogNewPostView, utils, template) ->
  "use strict"

  class HeaderView extends View

    el: "#menu"
    template: template
    autoRender: true
    events:
      "click #common-menu a": "navigate"
      "click #show-new-post": "showNewPost"
      "click #logout": "logout"
      "click #warning": "ignore"

    initialize: ->
      super
      #: How many events wait for the user attention
      @eventsCounter = 0
      @subscribeEvent "!ws:new_message", @incCounter
      @subscribeEvent "!ws:new_comment", @incCounter
      $(window).focus => @resetCounter()
      @subscribeEvent "!view:header:render", @render
      @subscribeEvent "!router:changeURL", (url) ->
        $("#common-menu>li").removeClass("active")
        a = $("#common-menu a[href='/#{url}']")
        if a.length
          a.parent().addClass("active")
      dialog = new DialogNewPostView()
      @subview "dialog", dialog

    # Reload controller even if url was not changed
    navigate: (e) ->
      url = $(e.currentTarget).attr("href")
      utils.gotoUrl url
      # For some reason jQuery's event.preventDefault() doesn't work here
      false

    showNewPost: (e) ->
      e.preventDefault()
      return unless utils.isLogged()
      @subview("dialog").show()

    logout: (e) ->
      e.preventDefault()
      utils.clearAuth()
      @render()
      utils.gotoUrl "/"

    afterRender: ->
      super
      @$(".dropdown-toggle").dropdown()

    ignore: (e) ->
      e.preventDefault()

    # Favicon actions

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
