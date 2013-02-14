define [
  "jquery"
  "chaplin"
  "lib/utils"
], ($, Chaplin, utils) ->
  "use strict"

  class Model extends Chaplin.Model

    apiCall: (func = @id, data = undefined) ->
      deferred = $.Deferred()
      promise = deferred.promise()

      reqData = if data? then data else @query
      method = if data? then "POST" else "GET"
      d = utils.apiCall func, reqData, method
      d.done (resData) =>
        # FIXME: Not sure if GC will correctly clean up callbacks
        deferred.resolve resData unless @disposed
      promise
