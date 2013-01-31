define [
  "chaplin"
  "views/main"
], (Chaplin, MainView) ->
  "use strict"

  class MainController extends Chaplin.Controller

    show: (params) ->
      @view = new MainView()

    test: ->
      console.log "passed!"
