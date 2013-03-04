define [
  "views/base/view"
  "lib/utils"
], (View, utils) ->
  "use strict"

  class RefreshDateView extends View

    initialize: (options) ->
      super options
      @subscribeEvent "!view:refreshDate:tick", @refreshDate

    afterRender: ->
      super
      @refreshDate()

    refreshDate: ->
      abbr = @$(".post-date, .comment-date")
      if abbr.length
        abbr.text(utils.formatDate @model.get "date")

    tick: ->
      # XXX: Fat arrow won't help here because `tick` called
      # outside from the setInterval.
      View::publishEvent "!view:refreshDate:tick"
