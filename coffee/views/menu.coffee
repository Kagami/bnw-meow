define [
  "jquery"
  "chaplin"
  "views/base/view"
  "views/dialog_new_post"
  "lib/utils"
  "templates/menu"
], ($, Chaplin, View, DialogNewPostView, utils, template) ->
  "use strict"

  class MenuView extends View

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
      @subscribeEvent "!view:menu:render", @render
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
