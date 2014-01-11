commonJsWrapper = (path, data) ->
  module = path.replace /^app(\/scripts)?\//, ""
  module = module.replace /(.*)\.\w+$/, "$1"
  prefix:
    """
    require.register("#{module}", function(exports, require, module) {
    "use strict";\n\n
    """
  suffix: "});\n\n"

exports.config =
  files:
    javascripts:
      joinTo:
        "static/meow.js"
      order:
        before: [
          # Required by Backbone and others.
          "vendor/underscore.js"
        ]
    stylesheets:
      joinTo:
        "static/meow.css"
    templates:
      joinTo:
        "static/meow.js"

  modules:
    wrapper: (path, data) ->
      if path.match /^app\//
        commonJsWrapper path, data
      else
        data

  conventions:
    # To prevent coping bootstrap assets into public/css and public/js.
    assets: /^app\/assets\//

  server:
    port: 4000

  sourceMaps: false
