define [
  "chaplin"
  "views/header"
], (Chaplin, HeaderView) ->
  "use strict"

  class HeaderController extends Chaplin.Controller

    initialize: ->
      @view = new HeaderView()
