define [
  "chaplin"
  "models/single_post"
  "views/single_post"
], (Chaplin, SinglePost, SinglePostView) ->
  "use strict"

  class SinglePostController extends Chaplin.Controller

    show: (params) ->
      @model = new SinglePost {}, post: params.post
      @view = new SinglePostView model: @model
