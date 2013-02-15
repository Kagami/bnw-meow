define [
  "chaplin"
  "views/menu"
  "lib/utils"
], (Chaplin, MenuView, utils) ->
  "use strict"

  class MenuController extends Chaplin.Controller

    initialize: ->
      @view = new MenuView()
      utils.setGlobal "menuView", @view
