# XXX: We must define all controllers explicitly here because otherwise
# require.js optimizer cannot find them then tracing dependencies.
define [
  "controllers/main_controller"
  "controllers/top_controller"
], ->
  "use strict"

  (match) ->
    match "", "main#show"
    match "top", "top#show"
