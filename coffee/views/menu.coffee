define [
  "jquery"
  "chaplin"
  "views/base/view"
  "lib/utils"
], ($, Chaplin, View, utils) ->
  "use strict"

  class MenuView extends View

    el: "#menu"
    events:
      "click a": "navigate"

    initialize: ->
      super
      Chaplin.mediator.subscribe "!router:changeURL", (url) =>
        @$("li").removeClass("active")
        a = @$("li a[href='/#{url}']")
        if a.length
          a.parent().addClass("active")

    # Reload controller even if url was not changed
    navigate: (e) ->
      url = $(e.currentTarget).attr("href")
      utils.gotoUrl url
      # For some reason jQuery's event.preventDefault() doesn't work here
      false
