define [
  "views/base/view"
  "lib/utils"
], (View, utils) ->
  "use strict"

  class RefreshDateView extends View

    afterInitialize: ->
      super
      @intervalId = setInterval @refreshDate, 60000

    dispose: ->
      clearInterval @intervalId
      super

    afterRender: ->
      super
      @refreshDate()

    refreshDate: =>
      abbr = @$(".post-date, .comment-date")
      if abbr.length
        date = @model.getAttributes().date
        abbr.text(utils.formatDate date)
