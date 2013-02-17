define [
  "jquery"
  "chaplin"
  "views/base/view"
  "lib/utils"
  "templates/menu"
], ($, Chaplin, View, utils, template) ->
  "use strict"

  class MenuView extends View

    el: "#menu"
    template: template
    autoRender: true
    events:
      "click #common_menu a": "navigate"
      "click #logout": "logout"

    initialize: ->
      super
      @subscribeEvent "!router:changeURL", (url) ->
        $("#common_menu>li").removeClass("active")
        a = $("#common_menu a[href='/#{url}']")
        if a.length
          a.parent().addClass("active")

    # Reload controller even if url was not changed
    navigate: (e) ->
      url = $(e.currentTarget).attr("href")
      utils.gotoUrl url
      # For some reason jQuery's event.preventDefault() doesn't work here
      false

    logout: (e) ->
      e.preventDefault()
      utils.clearAuth()
      @render()
      utils.gotoUrl "/"

    afterRender: ->
      super
      @$(".dropdown-toggle").dropdown()
