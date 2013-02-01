"use strict"

VERSION = ""

requirejs.config
  baseUrl: "/static/js/"
  urlArgs: "v=#{VERSION}"

require [
  "meow_application"
], (MeowApplication) ->
  app = new MeowApplication()
  app.initialize()
