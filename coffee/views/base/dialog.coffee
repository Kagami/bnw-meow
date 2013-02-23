define [
  "views/base/view"
], (View) ->
  "use strict"

  class DialogView extends View
    ###Base dialog class.###

    afterRender: ->
      super
      @modal = @$el.children(":first")

    isVisible: ->
      @modal.is(":visible")

    show: ->
      @modal.modal "show"

    hide: ->
      @modal.modal "hide"
