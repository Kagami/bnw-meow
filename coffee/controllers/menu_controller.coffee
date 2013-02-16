define [
  "chaplin"
  "views/menu"
  "lib/utils"
], (Chaplin, MenuView, utils) ->
  "use strict"

  class MenuController extends Chaplin.Controller

    initialize: ->
      menuView = new MenuView()
      utils.setGlobal "menuView", menuView
