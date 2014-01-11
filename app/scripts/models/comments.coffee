define [
  "models/base/collection"
  "models/comment"
], (Collection, Comment)  ->
  "use strict"

  class Comments extends Collection

    model: Comment
