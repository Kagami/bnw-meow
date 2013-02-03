define [
  "chaplin",
  "views/base/view"
], (Chaplin, View) ->
  "use strict"

  class CollectionView extends Chaplin.CollectionView

    animationDuration: 300

    getTemplateFunction: View::getTemplateFunction
