define ->
  "use strict"

  view_helpers =

    bnwUrl: (path) ->
      "https://bnw.im#{path}"

    formatDate: (date) ->
      date.fromNow()

    formatDateLong: (date) ->
      date.format("YYYY-MM-DD HH:mm")
