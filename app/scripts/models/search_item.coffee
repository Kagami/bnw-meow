_ = require "underscore"
moment = require "moment"
Model = require "models/base/model"
utils = require "lib/utils"
formatters = require "lib/formatters"

module.exports = class SearchItem extends Model
  DESTINY_DAY: moment.utc([2013, 1, 28])

  getAttributes: ->
    klass = if @get("type") == "message" then "post" else "comment"
    id2 = @get("id").replace "/", "#"
    tagsInfo = @get("tags_info").split(" ")
    tags = tagsInfo.filter((tag) -> tag[0] == "*").map((tag) -> tag[1..])
    clubs = tagsInfo.filter((club) -> club[0] == "!").map((club) -> club[1..])

    text = @get "text"
    date = moment.unix(@get "date")
    # XXX: Determine formatting based on the message date.
    # Yeap, that is extremely kludgy but since search DB has
    # no such info that's the only way.
    format = if date.isBefore(@DESTINY_DAY) then "moinmoin" else undefined
    text = utils.truncatePost text, format, @get("id")
    formattedText = formatters.format text, format

    _({
        klass, id2
        tags, clubs
        formattedText
      }).extend @attributes
