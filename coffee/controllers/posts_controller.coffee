define [
  "chaplin"
  "models/posts"
  "views/posts"
], (Chaplin, Posts, PostsView) ->
  "use strict"

  class PostsController extends Chaplin.Controller

    show: (params) ->
      id = params.id
      if params.isClub
        query = club: params.club
      else if params.isTag
        query = tag: params.tag
      else
        query = {}
      @collection = new Posts [], id: id, query: query
      @view = new PostsView collection: @collection
      @adjustTitle params.title
