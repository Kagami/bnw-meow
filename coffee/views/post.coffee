define [
  "views/base/view"
  "lib/utils"
  "templates/post"
], (View, utils, template) ->
  "use strict"

  class PostView extends View

    template: template

    afterInitialize: ->
      super
      @intervalId = setInterval @refreshDate, 60000

    dispose: ->
      clearInterval @intervalId
      super

    afterRender: ->
      @refreshDate()

    refreshDate: =>
      abbr = @$(".post-date")
      date = @model.getAttributes().date
      abbr.text(utils.formatDate date)
