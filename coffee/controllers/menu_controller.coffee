define [
  "chaplin"
  "views/menu"
], (Chaplin, MenuView) ->
  "use strict"

  class MenuController extends Chaplin.Controller

    initialize: ->
      @view = new MenuView()
