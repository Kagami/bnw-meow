define [
  "underscore"
  "models/post"
  "views/base/collection_view"
  "views/post"
  "views/dialog_delete"
  "lib/websocket_handler"
  "templates/posts"
], (_, Post, CollectionView, PostView, DialogDeleteView, WebSocketHandler,
    template) ->
  "use strict"

  class PostsView extends CollectionView

    _(@prototype).extend WebSocketHandler

    container: "#main"
    template: template
    itemView: PostView

    getView: (model) ->
      new @itemView model: model, dialog: @subview "dialog"

    afterInitialize: ->
      super

      dialog = new DialogDeleteView()
      @subview "dialog", dialog

      d = @collection.fetch()
      d.always =>
        @$(".preloader").remove()
      d.done =>
        # TODO: Move it to the collection?
        #@initWebSocket()

    onNewMessage: (postData) ->
      # TODO: Add with special styles.
      post = new Post postData
      @collection.add post, at: 0
