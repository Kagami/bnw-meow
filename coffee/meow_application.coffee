define [
  "chaplin"
  "views/layout"
  "controllers/menu_controller"
  "routes"
], (Chaplin, Layout, MenuController, routes) ->
  "use strict"

  class MeowApplication extends Chaplin.Application

    title: "BnW"

    initialize: ->
      super

      # Initialize core components
      @initDispatcher()
      @initLayout()
      @initMediator()

      # Application-specific scaffold
      @initControllers()

      # Register all routes and start routing
      @initRouter routes

      # Freeze the application instance to prevent further changes
      Object.freeze? this

    # Override standard layout initializer
    initLayout: ->
      # Use an application-specific Layout class. Currently this adds
      # no features to the standard Chaplin Layout, it’s an empty placeholder.
      @layout = new Layout {@title}

    # Instantiate common controllers
    initControllers: ->
      new MenuController()

    # Create additional mediator properties
    initMediator: ->
      # Create a user property
      Chaplin.mediator.user = null
      # Add additional application-specific properties and methods
      # Seal the mediator
      Chaplin.mediator.seal()
