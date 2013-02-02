"use strict"

config =
  baseUrl: "/static/js/"
  paths:
    jquery: "vendor/jquery"
    underscore: "vendor/underscore"
    backbone: "vendor/backbone"
    chaplin: "vendor/chaplin"
    cookie: "vendor/jquery.cookie"
    moment: "vendor/moment"
    moment_ru: "vendor/moment_ru"
  shim:
    underscore:
      exports: "_"
    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"
    cookie:
      deps: ["jquery"]
  urlArgs: "v=" + (new Date()).getTime()

if exports?
  # Run from Node. Export application config.
  exports.config = config
else
  # Development usage.
  requirejs.config config
  require [
    "meow_application"
  ], (MeowApplication) ->
    app = new MeowApplication()
    app.initialize()
