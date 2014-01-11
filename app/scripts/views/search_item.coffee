$ = require "jquery"
hljs = require "highlight"
RefreshDateView = require "views/base/refresh_date"
template = require "templates/search_item"

module.exports = class SearchItemView extends RefreshDateView
  template: template

  afterRender: ->
    super
    @$("pre code").each (i, e) ->
      hljs.highlightBlock e
