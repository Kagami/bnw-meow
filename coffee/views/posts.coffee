define [
  "underscore"
  "models/post"
  "views/base/collection_view"
  "views/post"
  "lib/websocket_handler"
  "lib/utils"
  "templates/posts"
], (_, Post, CollectionView, PostView, WebSocketHandler, utils, template) ->
  "use strict"

  class PostsView extends CollectionView

    _(@prototype).extend WebSocketHandler

    container: "#main"
    template: template
    itemView: PostView

    afterInitialize: ->
      super
      d = @collection.fetch()
      d.always =>
        @$(".preloader").remove()
      d.done =>
        #@initWebSocket()

    onNewMessage: (postData) ->
      # TODO: Add with special styles.
      post = new Post postData
      @collection.add post, at: 0
