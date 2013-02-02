# XXX: We must define all controllers explicitly here because otherwise
# require.js optimizer cannot find them then tracing dependencies.
define [
  "controllers/posts_controller"
], ->
  "use strict"

  (match) ->
    match "", "posts#show", params:
      title: "Главная"
    match "top", "posts#show", params:
      id: "today", title: "Топ 20 постов за сегодня"
