define [
  "chaplin"
  "lib/utils"
], (Chaplin, utils) ->
  "use strict"

  class Model extends Chaplin.Model

    urlRoot: utils.bnwUrl "/api"

    # XXX: We need to do this crap with request methods
    # and Content-Type because BnW's API is shit.
    apiCall: (url = @url(), data = undefined) ->
      $.ajax
        url: url
        type: if data? then "POST" else "GET"
        dataType: "json"
        data: data
