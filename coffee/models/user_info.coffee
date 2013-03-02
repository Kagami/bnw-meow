define [
  "underscore"
  "moment"
  "models/base/model"
  "lib/formatters"
  "lib/utils"
], (_, moment, Model, formatters, utils) ->
  "use strict"

  class UserInfo extends Model

    id: "userinfo"

    constructor: (attributes, options) ->
      super attributes, options
      @query = user: options.user

    getAttributes: ->
      vcard = @get "vcard"
      formattedAbout = if @get("about").length
        formatters.format @get "about"
      else
        undefined
      regdate = moment.unix(@get "regdate")
      registeredDaysAgo = moment().diff(regdate, "days")

      # If user hasn't logged in this attributes has no sence
      subscribed = utils.getUser() in @get "subscribers_all"
      itsMe = utils.getUser() == @get "user"

      _({formattedAbout,
         registeredDaysAgo,
         subscribed, itsMe}).extend @attributes
