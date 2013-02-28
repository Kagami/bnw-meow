define [
  "underscore"
  "models/base/model"
  "lib/utils"
  "lib/formatters"
], (_, Model, utils, formatters)  ->
  "use strict"

  class Post extends Model

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

      formattedText = formatters.format @get("text"), @get("format")

      _({recommendationsTitle,
         recommended,
         canDelete,
         formattedText}).extend @attributes
