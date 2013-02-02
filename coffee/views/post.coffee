define [
  "views/base/view"
  "templates/post"
], (View, template) ->
  "use strict"

  class PostView extends View

    template: template
    autoRender: true
    className: "post"
