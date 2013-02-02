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
        a = @$("a[href='/#{url}']")
        a = $("#main_item") unless a.length
        @$("li").removeClass("active")
        a.parent().addClass("active")

    navigate: (e) ->
      url = $(e.currentTarget).attr("href")
      mediator.publish "!router:route", url, forceStartup: true
      return false
