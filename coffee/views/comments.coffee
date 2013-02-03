define [
  "views/base/collection_view"
  "views/comment"
], (CollectionView, CommentView) ->
  "use strict"

  class CommentsView extends CollectionView

    el: "#comments"
    itemView: CommentView
