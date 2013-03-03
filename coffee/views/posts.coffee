define [
  "jquery"
  "underscore"
  "models/post"
  "views/base/collection_view"
  "views/post"
  "views/user_info"
  "views/dialog_delete"
  "lib/utils"
  "templates/posts"
  "templates/preloader"
], ($, _, Post, CollectionView, PostView, UserInfoView, DialogDeleteView,
    utils, template, preloader) ->
  "use strict"

  class PostsView extends CollectionView

    container: "#main"
    template: template
    listSelector: "#posts"
    itemView: PostView
    autoRender: false

    SCROLL_THRESHOLD: 300

    getView: (model) ->
      new @itemView
        model: model
        dialog: @subview "dialog"
        pageUser: @pageUser

    initialize: (options) ->
      super options
      if options?.pageble?
        @pageble = options.pageble
      else
        @pageble = true

      dialog = new DialogDeleteView()
      @subview "dialog", dialog

      @show = options.show
      @pageUser = options.pageUser
      @templateData = pageUser: @pageUser
      # We should manually call render because we don't know about
      # page's user before initialize.
      @render()
      if @pageUser?
        # FIXME: Horrible and confused name choice for different
        # purposes: 'postUser', 'pageUser', 'user', 'getUser'.
        userInfo = new UserInfoView user: @pageUser, show: @show
        @subview "user-info", userInfo

      @fetch(true)?.done =>
        @subscribeEvent "!ws:new_message", @onNewPost
        @initWebSocket()

    fetch: (first = false) ->
      return if @$list.children(".preloader").length
      unless first
        if @collection.hasPages() then @collection.incPage() else return

      @$list.append utils.renderTemplate preloader
      d = @collection.fetch()
      d.always =>
        @$list.children(".preloader").remove()

    afterRender: ->
      super
      $(window).scroll @onScroll if @pageble

    dispose: ->
      $(window).off "scroll", @onScroll
      super

    onScroll: =>
      position = $(window).scrollTop() + $(window).height()
      height = $(document).height()
      @fetch() if height - position < @SCROLL_THRESHOLD

    onNewPost: (postData) ->
      post = new Post postData
      @collection.add post, at: 0
