# XXX: We must define all controllers explicitly here because otherwise
# require.js optimizer cannot find them then tracing dependencies.
define [
  "controllers/posts_controller"
  "controllers/single_post_controller"
  "controllers/login_controller"
], ->
  "use strict"

  (match) ->
    match "", "posts#show", params: title: "Главная"
    match "c/:club", "posts#show"
    match "t/:tag", "posts#show"
    match "u/:user", "posts#show"
    match "u/:user/t/:tag", "posts#show"
    match "top", "posts#show", params:
      id: "today", title: "Топ 20 постов за сегодня", pageble: false
    match "p/:post", "single_post#show"
    match "login", "login#login"
