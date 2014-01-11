Chaplin = require "chaplin"
SinglePost = require "models/single_post"
SinglePostView = require "views/single_post"

module.exports = class SinglePostController extends Chaplin.Controller
  show: (params) ->
    @model = new SinglePost {}, post: params.post
    @view = new SinglePostView model: @model
