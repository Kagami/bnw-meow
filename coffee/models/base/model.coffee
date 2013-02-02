define [
  "chaplin"
  "lib/utils"
], (Chaplin, utils) ->
  "use strict"

  class Model extends Chaplin.Model

    urlRoot: utils.bnwUrl "/api"

    apiCall: (url = @url(), data = undefined) ->
      reqData = if data? then data else @query
      $.ajax
        url: url
        type: if data? then "POST" else "GET"
        data: reqData
        # This should actually be auto-detectable (backend do return
        # correct Content-type header) but jQuery sucks.
        dataType: "json"
