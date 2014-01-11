define [
  "jquery"
  "chaplin"
  "lib/utils"
], ($, Chaplin, utils) ->
  "use strict"

  class Model extends Chaplin.Model

    fetch: ->
      # XXX: Actually all should work through standart Backbone
      # methods but BnW's API is crap so we do a lot of horrible
      # boilerplate.
      @apiCall().done (data) =>
        @set data

    apiCall: (func = @id, data = undefined) ->
      deferred = $.Deferred()
      promise = deferred.promise()

      reqData = if data? then data else @query
      method = if data? then "POST" else "GET"
      d = utils.apiCall func, reqData, method
      d.done (resData) =>
        deferred.resolve resData unless @disposed
      d.fail (err) =>
        deferred.reject err unless @disposed
      promise
