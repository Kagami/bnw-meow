define [
  "underscore"
  "models/base/model"
  "lib/utils"
], (_, Model, utils)  ->
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

      _({recommendationsTitle, recommended, canDelete}).extend @attributes
