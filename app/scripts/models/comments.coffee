Collection = require "models/base/collection"
Comment = require "models/comment"

module.exports = class Comments extends Collection
  model: Comment
