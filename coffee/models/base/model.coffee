define [
  "jquery"
  "chaplin"
  "lib/utils"
], ($, Chaplin, utils) ->
  "use strict"

  class Model extends Chaplin.Model

    urlRoot: utils.bnwUrl "/api"

    apiCall: (url = @url(), data = undefined) ->
      deferred = $.Deferred()
      promise = deferred.promise()
      reqData = if data? then data else @query
      jqxhr = $.ajax
        url: url
        type: if data? then "POST" else "GET"
        data: reqData
        # This should actually be auto-detectable (backend do return
        # correct Content-type header) but jQuery sucks.
        dataType: "json"
      jqxhr.done (data) =>
        # XXX: Not sure if GC will correctly clean up callbacks on 'done'
        deferred.resolve data unless @disposed
      promise
