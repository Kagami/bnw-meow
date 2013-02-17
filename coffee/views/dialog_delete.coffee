define [
  "underscore"
  "views/base/view"
  "views/post"
  "views/comment"
  "lib/utils"
  "templates/dialog_delete"
], (_, View, PostView, CommentView, utils, template) ->
  "use strict"

  class DialogDeleteView extends View

    container: "body"
    template: template
    autoRender: true
    events:
      "click .delete-selected": "deleteSelected"
      "click .cancel-delete": "cancelDelete"

    MARK_OPTIONS: [
      [".post-delete", "post-delete-marked"]
      [".comment-delete", "comment-delete-marked"]
    ]

    initialize: (options) ->
      super options
      @selected = []
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
        @selected.forEach @_toggleMark
        @selected = []

    isVisible: ->
      @modal.is(":visible")

    show: ->
      @modal.modal "show"

    hide: ->
      @modal.modal "hide"

    _toggleMark: (obj) =>
      index = if obj instanceof PostView then 0 else 1
      [selector, className] = @MARK_OPTIONS[index]
      obj.$(selector).toggleClass(className)

    toggleMark: (obj) ->
      singlePostMarked = @singlePost and obj instanceof PostView
      @_toggleMark obj
      if obj in @selected
        @selected = _(@selected).without obj
      else
        if @singlePost
          # Special case: at the single post page allow select either
          # entire post or comments.
          if singlePostMarked
            @selected.forEach @_toggleMark
            @selected = []
          else
            if @selected.length == 1 and @selected[0] instanceof PostView
              @_toggleMark @selected[0]
              @selected = []
        @selected.push obj

      if @selected.length
        forDelete = if singlePostMarked
          "пост"
        else
          utils.pluralForm @selected.length, @pluralForms
        @$(".for-delete").text(forDelete)
        @show() unless @isVisible()
      else
        @hide()

    deleteSelected: (e) ->
      e.preventDefault()
      @selected.forEach (obj) -> obj.model.destroy()
      @hide()

    cancelDelete: (e) ->
      e.preventDefault()
      @hide()
