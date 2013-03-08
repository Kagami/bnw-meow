###
Scrollable multipage collection view.
###

define [
  "jquery"
  "views/base/collection_view"
  "lib/utils"
  "templates/preloader"
], ($, CollectionView, utils, preloader) ->
  "use strict"

  class ScrollableView extends CollectionView

    #: How far from the end of screen (in pixels) another page
    #: should start loading.
    scrollThreshold: 300
    #: Does the view has many pages or it's always one page
    #: and shouldn't be scrolled.
    scrollable: true

    afterRender: ->
      super
      $(window).scroll @onScroll if @scrollable

    dispose: ->
      $(window).off "scroll", @onScroll
      super

    onScroll: =>
      position = $(window).scrollTop() + $(window).height()
      height = $(document).height()
      @fetch() if height - position < @scrollThreshold

    fetch: ->
      return if @$list.children(".preloader").length
      return unless @collection.hasPages()

      @$list.append utils.renderTemplate preloader
      d = @collection.fetch()
      d.always =>
        @$list.children(".preloader").remove()
      d.done (data) =>
        if @collection.isEmptyPage(data) and not @collection.length
          @$list.append utils.renderTemplate @notFoundTemplate
        else
          @collection.incPage()
