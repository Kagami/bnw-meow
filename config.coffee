exports.config =
  files:
    javascripts:
      joinTo:
        "static/meow.js"
      order:
        before: [
          "vendor/underscore.js"
        ]
    stylesheets:
      joinTo:
        "static/meow.css"
    templates:
      joinTo:
        "static/meow.js"

  conventions:
    # To prevent coping bootstrap assets into public/css and public/js
    assets: /^app\/assets\//

  server:
    port: 4000

  sourceMaps: false
