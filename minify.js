#!/usr/bin/env node

var requirejs = require("requirejs");
var config = require("./dist/static/js/load").config;

// Prepare config for optimizing
config.baseUrl = "dist/static/js/";
config.name = "meow_application";
config.out = "deb_dist/srv/bnw-meow/static/js/meow.js";
config.paths.requireLib = "vendor/require";
config.include = ["requireLib"];
config.logLevel = 0;

requirejs.optimize(config);
