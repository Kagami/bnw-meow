_ = require "underscore"
moment = require "moment"
Model = require "models/base/model"
formatters = require "lib/formatters"
utils = require "lib/utils"

module.exports = class UserInfo extends Model
  id: "userinfo"

  constructor: (attributes, options) ->
    super attributes, options
    @query = user: options.user

  getAttributes: ->
    vcard = @get "vcard"
    formattedUrl = if vcard.url?
      # Escaping is important but not that much since we
      # will pass it through markdown formatter.
      # But we should pass only urls in url field so it
      # should be no hacks like 'test> **haha**'.
      url = formatters.escape2 vcard.url
      formatters.format "<#{url}>"
    else
      undefined
    formattedAbout = if @get("about").length
      formatters.format @get "about"
    else
      undefined
    regdate = moment.unix(@get "regdate")
    formattedRegdate = regdate.format("YYYY-MM-DD")
    registeredDaysAgo = moment().diff(regdate, "days")

    # If user hasn't logged in this attributes has no sence
    subscribed = utils.getUser() in @get "subscribers_all"
    itsMe = utils.getUser() == @get "user"

    _({
        formattedUrl, formattedAbout,
        formattedRegdate, registeredDaysAgo
        subscribed, itsMe
      }).extend @attributes
