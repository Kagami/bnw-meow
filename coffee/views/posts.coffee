define [
  "models/post"
  "views/base/scrollable"
  "views/post"
  "views/user_info"
  "views/dialog_delete"
  "templates/posts"
  "templates/no_posts"
], (Post, ScrollableView, PostView, UserInfoView, DialogDeleteView, template,
    notFound) ->
  "use strict"

  class PostsView extends ScrollableView

    container: "#main"
    template: template
    listSelector: "#posts"
    itemView: PostView
    autoRender: false
    notFoundTemplate: notFound

    getView: (model) ->
      new @itemView
        model: model
        dialog: @subview "dialog"
        pageUser: @pageUser

    initialize: (options) ->
      super options
      if options?.scrollable?
        @scrollable = options.scrollable

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

      @fetch()?.done =>
        @subscribeEvent "!ws:new_message", @onNewPost
        @initWebSocket()

    onNewPost: (postData) ->
      post = new Post postData
      @collection.add post, at: 0
