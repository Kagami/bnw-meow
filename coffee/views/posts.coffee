define [
  "views/base/collection_view"
  "views/post"
], (CollectionView, PostView) ->
  "use strict"

  class PostsView extends CollectionView

    el: "#main"
    itemView: PostView
    animationDuration: 300
