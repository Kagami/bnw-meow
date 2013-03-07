define [
  "underscore"
  "models/base/model"
  "lib/formatters"
], (_, Model, formatters)  ->
  "use strict"

  class SearchItem extends Model

    getAttributes: ->
      tagsInfo = @get("tags_info").split(" ")
      tags = tagsInfo.filter((tag) -> tag[0] == "*").map((tag) -> tag[1..])
      clubs = tagsInfo.filter((club) -> club[0] == "!").map((club) -> club[1..])
      formattedText = formatters.format @get "text"
      recommendations = []
      _({
          tags, clubs
          recommendations
          formattedText
        }).extend @attributes
