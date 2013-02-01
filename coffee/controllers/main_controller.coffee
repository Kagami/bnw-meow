define [
  "chaplin"
  "views/main"
  "models/posts"
], (Chaplin, MainView, Posts) ->
  "use strict"

  class MainController extends Chaplin.Controller

    show: (params) ->
      @model = new Posts()
      @model.fetch()
      @view = new MainView model: @model
