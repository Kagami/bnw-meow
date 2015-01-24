CollectionView = require "views/base/collection_view"
CommentView = require "views/comment"
utils = require "lib/utils"

module.exports = class CommentsView extends CollectionView
  el: "#comments"
  itemView: CommentView

  getView: (model) ->
    new @itemView model: model, dialog: @dialog

  initialize: (options) ->
    super options
    @dialog = options.dialog

  afterRender: ->
    super
    # Treeify comments
    @collection.forEach (comment) ->
      attributes = comment.getAttributes()
      id = attributes.commentId
      replyto = attributes.replyCommentId
      if replyto?
        target = $("##{replyto}").parent()
        if target.length
          source = $("##{id}").parent()
          target.append(source)
      utils.addReplyLink(id,replyto)
