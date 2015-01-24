$ = require "jquery"
_ = require "underscore"
moment = require "moment"
Chaplin = require "chaplin"
HeaderController = require "controllers/header_controller"
routes = require "routes"
utils = require "lib/utils"

class MeowApplication extends Chaplin.Application
  title: "BnW"

  initialize: ->
    super

    @initSettings()

    # Initialize core components
    @initDispatcher()
    @initLayout()
    @initMediator()

    # Application-specific scaffold
    @initControllers()
    # Register all routes and start routing
    @initRouter routes

    utils.bindLinkOnHover()
    utils.bindCommentOnHover()

    # Freeze the application instance to prevent further changes
    Object.freeze? this

  initSettings: ->
    moment.lang("ru")

  # Override standard layout initializer
  initLayout: ->
    @layout = new Chaplin.Layout
      title: @title
      titleTemplate: _.template("<%= title %> — <%= subtitle %>")

  # Instantiate common controllers
  initControllers: ->
    new HeaderController()

  # Create additional mediator properties
  initMediator: ->
    # Create a user property
    Chaplin.mediator.user = null
    # Add additional application-specific properties and methods
    # Seal the mediator
    Chaplin.mediator.seal()

# Starting point.
$ ->
  app = new MeowApplication()
  app.initialize()
