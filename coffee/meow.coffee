define [
  "chaplin"
  "views/layout"
  "routes"
], (Chaplin, Layout, routes) ->
  "use strict"

  class MeowApplication extends Chaplin.Application

    title: "BnW"

    initialize: ->
      super

      # Initialize core components
      @initDispatcher()
      @initLayout()
      @initMediator()

      # Register all routes and start routing
      @initRouter routes
      # You might pass Router/History options as the second parameter.
      # Chaplin enables pushState per default and Backbone uses / as
      # the root per default. You might change that in the options
      # if necessary:
      # @initRouter routes, pushState: false, root: "/subdir/"

      # Freeze the application instance to prevent further changes
      Object.freeze? this

    # Override standard layout initializer
    initLayout: ->
      # Use an application-specific Layout class. Currently this adds
      # no features to the standard Chaplin Layout, it’s an empty placeholder.
      @layout = new Layout {@title}

    # Create additional mediator properties
    initMediator: ->
      # Create a user property
      Chaplin.mediator.user = null
      # Add additional application-specific properties and methods
      # Seal the mediator
      Chaplin.mediator.seal()
