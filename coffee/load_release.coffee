"use strict"

VERSION = ""

requirejs.config
  baseUrl: "/static/js/"
  urlArgs: "v=#{VERSION}"
  deps: ["bootstrap", "cookie"]

require [
  "meow_application"
], (MeowApplication) ->
  app = new MeowApplication()
  app.initialize()
