define [
  "chaplin"
  "models/posts"
  "views/posts"
], (Chaplin, Posts, PostsView) ->
  "use strict"

  class PostsController extends Chaplin.Controller

    show: (params) ->
      # Unescape matched parts of url.
      # Why the hell chaplin doesn't do it by himself?
      # XXX: Seems like what we should use encodeURIComponent
      # and then decode it for each url parameter like user or id
      # but we hope that they will not contain "bad" characters
      # in future.
      params.tag = decodeURIComponent params.tag if params.tag?
      params.club = decodeURIComponent params.club if params.club?

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
