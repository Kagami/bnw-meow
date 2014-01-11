# XXX: We must define all controllers explicitly here because otherwise
# require.js optimizer cannot find them when tracing dependencies.
define [
  "controllers/posts_controller"
  "controllers/single_post_controller"
  "controllers/login_controller"
  "controllers/search_controller"
], ->
  "use strict"

  (match) ->
    match "", "posts#show", params: title: "Главная"
    match "c/:club", "posts#show"
    match "t/:tag", "posts#show"
    match "p/:post", "single_post#show"
    match "search/:query", "search#show"
    match "login", "login#login"
    match "top", "posts#show", params:
      id: "today", title: "Топ 20 постов за сегодня", scrollable: false
    match "feed", "posts#show", params:
      id: "feed", title: "Подписки"

    match "u/:user", "posts#show", params:
      show: "messages"
    match "u/:user/all", "posts#show", params:
      show: "all"
    match "u/:user/recommendations", "posts#show", params:
      show: "recommendations"
    match "u/:user/t/:tag", "posts#show"
