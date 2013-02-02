define [
  "chaplin"
  "models/posts"
  "views/posts"
], (Chaplin, Posts, PostsView) ->
  "use strict"

  class TopController extends Chaplin.Controller

    show: (params) ->
      @collection = new Posts [], id: "today"
      @view = new PostsView collection: @collection
