# XXX: We must define all controllers explicitly because otherwise
# require.js optimizer cannot find them.
define [
  "controllers/main_controller"
], ->
  "use strict"

  (match) ->
    match "", "main#show"
