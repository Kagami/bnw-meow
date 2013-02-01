define [
  "models/base/collection"
  "models/post"
], (Collection, Post)  ->
  "use strict"

  class Posts extends Collection

    model: Post
    id: "show"
    container: "#posts"
