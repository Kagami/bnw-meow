define [
  "chaplin"
  "models/posts"
  "views/posts"
], (Chaplin, Posts, PostsView) ->
  "use strict"

  class PostsController extends Chaplin.Controller

    show: (params) ->
      id = params.id
      id ?= "show"
      @collection = new Posts [], id: id
      @view = new PostsView collection: @collection
      @adjustTitle params.title
