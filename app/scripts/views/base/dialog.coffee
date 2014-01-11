View = require "views/base/view"

module.exports = class DialogView extends View
  ###Base dialog class.###

  autoRender: true

  afterRender: ->
    super
    @modal = @$el.children(":first")

  isVisible: ->
    @modal.is(":visible")

  show: ->
    @modal.modal "show"

  hide: ->
    @modal.modal "hide"
