define [
  "jquery"
  "views/base/view"
  "lib/utils"
  "templates/dialog_delete"
], ($, View, utils, template) ->
  "use strict"

  class DialogDeleteView extends View

    container: "body"
    template: template
    autoRender: true
    events:
      "click .delete-selected": "deleteSelected"
      "click .cancel-delete": "cancelDelete"

    # XXX: We use here Slow selectors and there is some code
    # duplication in post/comment views.
    # Hope this will not be slow as shit.
    MARKED_POST_CLASS: "post-delete-marked"
    MARKED_COMMENT_CLASS: "comment-delete-marked"
    MARKED_SELECTOR:
      ".#{@prototype.MARKED_POST_CLASS}, .#{@prototype.MARKED_COMMENT_CLASS}"
    MARKED_CLASSES:
      "#{@prototype.MARKED_POST_CLASS} #{@prototype.MARKED_COMMENT_CLASS}"

    initialize: (options) ->
      super options
      @singlePost = options?.singlePost
      @pluralForms = if @singlePost
        ["комментарий", "комментария", "комментариев"]
      else
        ["пост", "поста", "постов"]

    _getEl: ->
      @$el.children(":first")

    afterRender: ->
      super
      @modal = @_getEl()
      @modal.on "shown", =>
        @$(".cancel-delete").focus()
      @modal.on "hide", =>
        $(@MARKED_SELECTOR).removeClass(@MARKED_CLASSES)

    isVisible: ->
      @modal.is(":visible")

    show: ->
      @modal.modal "show"

    hide: ->
      @modal.modal "hide"

    updateMarked: (singlePostMarked = false) ->
      marked = $(@MARKED_SELECTOR).length
      if marked
        @show() unless @isVisible()
        # Special case: at the single post page allow select either
        # entire post or comments.
        if @singlePost
          if singlePostMarked
            $(".#{@MARKED_COMMENT_CLASS}").removeClass(@MARKED_COMMENT_CLASS)
          else
            post = $(".#{@MARKED_POST_CLASS}").removeClass(@MARKED_POST_CLASS)
            marked -= post.length  # Always will be 0 or 1
        forDelete = if singlePostMarked
          "пост"
        else
          utils.pluralForm marked, @pluralForms
        @$(".for-delete").text(forDelete)
      else
        @hide()

    deleteSelected: (e) ->
      e.preventDefault()
      $(@MARKED_SELECTOR).each ->
        div = $(this).closest(".post, .comment")
        id = div.attr("data-full-id")
        # FIXME: In the better world we will work with objects and
        # call destory method on them.
        utils.post "delete", message: id
      @hide()

    cancelDelete: (e) ->
      e.preventDefault()
      @hide()
