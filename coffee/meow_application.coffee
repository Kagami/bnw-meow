define [
  "jquery"
  "underscore"
  "moment"
  "moment_ru"
  "chaplin"
  "controllers/menu_controller"
  "routes"
], ($, _, moment, moment_ru, Chaplin, MenuController, routes) ->
  "use strict"

  class MeowApplication extends Chaplin.Application

    title: "BnW"

    initialize: ->
      super

      @initSettings()

      # Initialize core components
      @initDispatcher()
      @initLayout()
      @initMediator()

      # XXX: For some strange reason routing without delay
      # doesn't always work correctly in Firefox.
      $ =>
        # Application-specific scaffold
        @initControllers()
        # Register all routes and start routing
        @initRouter routes
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
      new MenuController()

    # Create additional mediator properties
    initMediator: ->
      # Create a user property
      Chaplin.mediator.user = null
      # Add additional application-specific properties and methods
      # Seal the mediator
      Chaplin.mediator.seal()
