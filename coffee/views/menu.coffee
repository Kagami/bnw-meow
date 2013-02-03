define [
  "jquery"
  "chaplin"
  "views/base/view"
], ($, Chaplin, View) ->
  "use strict"

  mediator = Chaplin.mediator

  class MenuView extends View

    el: "#menu"
    events:
      "click a": "navigate"

    initialize: ->
      super
      mediator.subscribe "!router:changeURL", (url) =>
        @$("li").removeClass("active")
        a = @$("li a[href='/#{url}']")
        if a.length
          a.parent().addClass("active")

    # Reload controller even if url was not changed
    navigate: (e) ->
      url = $(e.currentTarget).attr("href")
      mediator.publish "!router:route", url, forceStartup: true
      # For some reason jQuery's event.preventDefault() doesn't work here
      false
