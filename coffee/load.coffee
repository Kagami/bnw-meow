"use strict"

config =
  baseUrl: "/static/js/"
  paths:
    jquery: "vendor/jquery"
    underscore: "vendor/underscore"
    backbone: "vendor/backbone"
    chaplin: "vendor/chaplin"
    cookie: "vendor/jquery.cookie"
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
    "meow"
  ], (MeowApplication) ->
    app = new MeowApplication()
    app.initialize()
