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
    stylesheets:
      joinTo:
        "static/meow-bootstrap.css": /^app\/styles\/meow-bootstrap\.less$/
    templates:
      joinTo:
        "static/meow.js"

  modules:
    wrapper: (path, data) ->
      if path.match /^app\//
        commonJsWrapper path, data
      else
        data

  plugins:
    uglify:
      output:
        comments: /copyright|license|\(c\)/i

  conventions:
    # To prevent coping bootstrap assets into public/css and public/js.
    assets: /^app\/assets\//

  server:
    port: 4000

  sourceMaps: false
