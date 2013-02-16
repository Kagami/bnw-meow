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

    MARKED_POST_CLASS: "post-delete-marked"
    MARKED_COMMENT_CLASS: "comment-delete-marked"
    MARKED_SELECTOR:
      ".#{@prototype.MARKED_POST_CLASS}, .#{@prototype.MARKED_COMMENT_CLASS}"
    MARKED_CLASSES:
      "#{@prototype.MARKED_POST_CLASS} #{@prototype.MARKED_COMMENT_CLASS}"

    initialize: (options) ->
      super options
      @pluralForms = if options?.singlePost
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

    updateMarked: (singlePost = false) ->
      marked = $(@MARKED_SELECTOR)
      if marked.length
        @show() unless @isVisible()
        forDelete = if singlePost
          # Special case: close button on the entire post at the
          # single post page.
          $(".#{@MARKED_COMMENT_CLASS}").removeClass(@MARKED_COMMENT_CLASS)
          "пост"
        else
          utils.pluralForm marked.length, @pluralForms
        @$(".for-delete").text(forDelete)
      else
        @hide()

    deleteSelected: (e) ->
      e.preventDefault()
      $(@MARKED_SELECTOR).each ->
        post = $(this).closest(".post")
        post.remove()
        # TODO: Actual delete.
      @hide()

    cancelDelete: (e) ->
      e.preventDefault()
      @hide()
