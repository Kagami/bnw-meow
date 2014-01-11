_ = require "underscore"
Model = require "models/base/model"
utils = require "lib/utils"
formatters = require "lib/formatters"

module.exports = class Post extends Model
  destroy: ->
    @apiCall "delete", message: @get "id"

  getAttributes: ->
    # Because we could render template before the date has been
    # fetched.
    return {} if _(@attributes).isEmpty()

    recommendations = utils.truncate \
      @get("recommendations").map((u) -> "@" + u)
    recommendationsTitle = if recommendations.length
      "Рекомендовали: " + recommendations.join ", "
    else if utils.isLogged()
      "Рекомендовать"
    else
      "Рекомендации"

    recommended = utils.getUser() in @get "recommendations"

    canDelete = utils.getUser() == @get "user"

    text = @get "text"
    format = @get "format"
    # Skip truncate for single post
    if this instanceof Post
      text = utils.truncatePost text, format, @get("id")
    formattedText = formatters.format text, format

    _({
        recommendationsTitle
        recommended
        canDelete
        formattedText
      }).extend @attributes
