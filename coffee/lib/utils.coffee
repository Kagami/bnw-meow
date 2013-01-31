define [
  "underscore"
  "chaplin"
  'lib/view_helpers'
], (_, Chaplin, view_helpers) ->
  "use strict"

  utils = Chaplin.utils.beget Chaplin.utils

  _(utils).extend view_helpers,
    {}
