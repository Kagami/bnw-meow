Chaplin = require "chaplin"
HeaderView = require "views/header"

module.exports = class HeaderController extends Chaplin.Controller
  initialize: ->
    @view = new HeaderView()
