_ = require "underscore"
moment = require "moment"
config = require "config"

module.exports =
  getBnwUrl: (path) ->
    "#{config.BNW_API_PROTOCOL}://#{config.BNW_API_HOST}#{path}"

  getAvatarUrl: (username) ->
    "#{config.BNW_API_PROTOCOL}://#{config.BNW_API_HOST}"+
    "/u/#{username}/avatar/thumb"

  getThumbUrl: (imageUrl) ->
    imageUrl = encodeURIComponent imageUrl
    _.template(config.THUMBIFY_URL, {imageUrl})

  renderTemplate: (templateFunc, params = {}) =>
    templateFunc _(params).extend(this)

  formatDate: (date) ->
    moment.unix(date).fromNow()

  formatDateLong: (date) ->
    moment.unix(date).format("YYYY-MM-DD HH:mm:ss")

  truncate: (text, maxlength = 50) ->
    if text.length > maxlength
      text[...maxlength].concat "…"
    else
      text

  # Get and set login info via local storage bakend.

  LOGIN_KEY_NAME: "bnw-meow_login-key"
  USER_KEY_NAME: "bnw-meow_user"

  getLoginKey: ->
    localStorage.getItem @LOGIN_KEY_NAME

  setLoginKey: (loginKey) ->
    localStorage.setItem @LOGIN_KEY_NAME, loginKey

  clearLoginKey: ->
    localStorage.removeItem @LOGIN_KEY_NAME

  isLogged: ->
    @getLoginKey()?

  getUser: ->
    localStorage.getItem @USER_KEY_NAME

  setUser: (user) ->
    localStorage.setItem @USER_KEY_NAME, user

  clearUser: ->
    localStorage.removeItem @USER_KEY_NAME

  clearAuth: ->
    @clearLoginKey()
    @clearUser()

  addReplyLink: (id,replyto) ->
    replyto ?= "single-post"
    replyLink = '<a class="comment-reply-to label label-reset" href="#' + id + '">&gt;&gt;' + id + '</a> '
    $("##{replyto} .replies").append(replyLink)

  removeReplyLink: (id,replyto) ->
    replyto ?= "single-post"
    $("##{replyto} .replies").find('a').each (i,item) ->
      if item.href.match(/[0-9A-Z]*$/)[0] == id
        $(item).remove()

  bindHoverEvents: ->
    # let's create popup comments as divs with unique ids, copy linked post content to it, 
    # append id to chain on mouseenter, take id from chain on mouseleave and remove div
    # and let's delegate all applying handler job to jquery
    # (actually we put id to chain on create rather then mouseenter, because there could be no mouseenter, 
    # and we still need to remove div when we're done)

    chain = []
    chainIndex = 0
    linkParent = null
    focusedComment = false
    focusedLink = false

    removeAllChain = ->
      $('#' + chain.pop()).remove() while chain.length

    removeLastInChain = ->
      $('#' + chain.pop()).remove() if chain.length

    waitForHoverOnCommentOrLink = ->
      if not focusedComment and not focusedLink
        removeAllChain()
      if focusedComment and not focusedLink and chain.length and chain[chain.length-1] != focusedComment
        removeLastInChain()
        linkParent = null

    waitForHoverOnComment = ->
      if not focusedComment
        removeAllChain()

    linkHoverHandler = (e) ->
      if e.type == 'mouseenter'

        if linkParent == e.target.parentElement
          removeLastInChain()

        linkParent = e.target.parentElement

        commentId = e.target.href.match(/#[0-9A-Z]*$/)[0]
        xPadding = 40 + 15
        yPadding = 20 - 10

        # coordinates of popup (css properties)
        left = e.clientX + window.scrollX - xPadding
        top = e.clientY + window.scrollY - yPadding

        windowWidth = $(window).width()
        width = $(commentId).width()
        
        # fit comment to window (push from right border)
        left = Math.min(left + width + xPadding, windowWidth) - width - xPadding

        if $(commentId).length
          html = $(commentId).html()
        else
          html = "Комментарий от пользователя находящегося в чёрном списке"
        
        # unique id
        id = 'bnw-chan-comment-' + chainIndex++
        chain.push id
        $('<div/>',{
          id,html,'class': 'comment-wrapper comment well well-small bnw-chan-comment'
        }).appendTo('body').css({left,top,width,position:'absolute'})

        focusedLink = true    

      else if e.type == 'mouseleave'

        focusedLink = false
        setTimeout waitForHoverOnCommentOrLink, 1000

    # jquery will apply handler on all current and future elements
    $('body').on('hover','a.comment-reply-to',linkHoverHandler)

    commentHoverHandler = (e) ->      
      if e.type == 'mouseenter'
        id = e.currentTarget.id
        focusedComment = id
        linkParent = null
        index = chain.indexOf id
        if index>-1 
          # we jumped from popup to previous popup (hovered popup id are in chain)
          $('#' + chain.pop()).remove() while chain.length > index + 1
        else 
          # we jupmed to new popup
          chain.push id
      else if e.type == 'mouseleave'
        # when mouse goes from popup post to another popup post mouseleave triggered, then mouseenter triggered almost immedeately
        # if mouseenter are not triggered it means we left all chain of posts and all chain should be destroyed
        focusedComment = false
        setTimeout waitForHoverOnComment, 10

    # jquery will apply handler on all current and future elements
    $('body').on('hover','div.bnw-chan-comment',commentHoverHandler)
