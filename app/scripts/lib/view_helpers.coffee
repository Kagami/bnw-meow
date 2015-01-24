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

  bindLinkOnHover: ->
    # let's create popup comments as divs with unique ids, copy linked post content to it, 
    # append id to chain on mouseenter, take id from chain on mouseleave
    # and let's delegate all applying handler job to jquery

    chainIndex = 0
    hoverHandler = (e) ->
      if e.type == 'mouseenter'
        commentId = e.target.href.match(/#[0-9A-Z]*$/)[0]
        xPadding = 40 + 10
        yPadding = 20 + 10

        # coordinates of popup
        xPos = e.clientX + window.scrollX - xPadding
        yPos = e.clientY + window.scrollY - yPadding

        windowWidth = $(window).width()
        commentWidth = $(commentId).width()

        # fit comment to window (push from right border)
        xPos = Math.min(xPos + commentWidth + xPadding, windowWidth) - commentWidth - xPadding

        comment = $(commentId).html()

        # we need unique ids to handle chain obviously
        hoverId = 'bnw-chan-comment-' + chainIndex
        chainIndex = chainIndex + 1

        popupClass = "comment-wrapper comment well well-small bnw-chan-comment"
        popupHtml = '<div id="' + hoverId + '" class="' + popupClass + '" style="position: absolute;">' + comment + '</div>'
        $('body').append(popupHtml)
        $('#' + hoverId).css('left',xPos).css('top',yPos).css('width',commentWidth)

    # jquery will apply handler on all current and future elements
    $('body').on('hover','a.comment-reply-to',hoverHandler)


  bindCommentOnHover: ->
    chain = []
    focused = null
    waitForFocus = ->
      if focused == null
        $('#' + chain[i]).remove() for item,i in chain
        chain = []
    hoverHandler = (e) ->
      id = $(this).attr('id')
      if e.type == 'mouseenter'
        focused = id;
        index = chain.indexOf(id)
        if index>-1 
          # we jumped from popup to previous popup (hovered popup id are in chain)
          i = chain.length
          $('#' + chain[i]).remove() while --i > index
          chain = chain.slice(0,index+1)
        else 
          # we jupmed to new popup
          chain.push(id)
      else if e.type == 'mouseleave'
        # when mouse hovers over link, new post are shown, then mouseleave triggered, then mouseenter triggered almost immedeately
        # if mouseenter are not triggered, it means we left all chain of posts and all chain should be destroyed
        focused = null
        setTimeout(waitForFocus,10)

    # jquery will apply handler on all current and future elements
    $('body').on('hover','div.bnw-chan-comment',hoverHandler)
