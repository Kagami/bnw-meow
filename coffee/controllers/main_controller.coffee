define [
  "chaplin"
  "models/posts"
  "views/posts"
], (Chaplin, Posts, PostsView) ->
  "use strict"

  class MainController extends Chaplin.Controller

    show: (params) ->
      @collection = new Posts()
      @view = new PostsView collection: @collection
      @collection.fetch().done =>
        @view.$(".preloader-bar").remove()
