define [
  "chaplin"
  "models/posts"
  "views/posts"
], (Chaplin, Posts, PostsView) ->
  "use strict"

  class PostsController extends Chaplin.Controller

    show: (params) ->
      if params.user?
        query = user: params.user
        query.tag = params.tag if params.tag?
        params.title = "@#{params.user}"
      else if params.club?
        query = club: params.club
        params.title = "!#{params.club}"
      else if params.tag?
        query = tag: params.tag
        params.title = "*#{params.tag}"
      else
        query = {}
      @collection = new Posts [], id: params.id, query: query
      @view = new PostsView collection: @collection
      @adjustTitle params.title
