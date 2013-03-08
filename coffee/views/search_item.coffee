define [
  "jquery"
  "highlight"
  "views/base/refresh_date"
  "templates/search_item"
], ($, hljs, RefreshDateView, template) ->
  "use strict"

  class SearchItemView extends RefreshDateView

    template: template

    afterRender: ->
      super
      @$("pre code").each (i, e) ->
        hljs.highlightBlock e
