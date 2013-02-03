define [
  "views/base/collection_view"
  "views/post"
  "templates/posts"
], (CollectionView, PostView, template) ->
  "use strict"

  class PostsView extends CollectionView

    container: "#main"
    template: template
    itemView: PostView

    afterInitialize: ->
      super
      @collection.fetch().done =>
        @$(".preloader").remove()
