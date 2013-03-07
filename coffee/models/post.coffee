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

    SHORT_POST_LENGTH: 500

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
      if this instanceof Post and format isnt "moinmoin"
        # XXX: Of course it is much better to shrink post based on
        # it's rendered size but jquery.dotdotdot is so horrible slow.
        # (About 38ms for single middle-sized div. What the fuck?)
        if text.length > @SHORT_POST_LENGTH
          text = text[...@SHORT_POST_LENGTH]
          text += " […](/p/#{@get 'id'} \"Читать дальше\")"
      formattedText = formatters.format text, format

      _({
          recommendationsTitle
          recommended
          canDelete
          formattedText
        }).extend @attributes
