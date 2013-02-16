define [
  "views/base/collection_view"
  "views/comment"
], (CollectionView, CommentView) ->
  "use strict"

  class CommentsView extends CollectionView

    el: "#comments"
    itemView: CommentView

    getView: (model) ->
      new @itemView model: model, dialog: @dialog

    initialize: (options) ->
      super options
      @dialog = options.dialog
