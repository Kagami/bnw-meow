#!node_modules/.bin/coffee

STATIC_FILES = ["public/static/meow.js", "public/static/meow.css"]
HTML_PATH = "public/index.html"

fs = require "fs"
path = require "path"
crypto = require "crypto"

html = fs.readFileSync HTML_PATH, encoding: "utf-8"

for filepath in STATIC_FILES
  filedir = path.dirname filepath
  filename = path.basename filepath
  data = fs.readFileSync filepath
  hash = crypto.createHash("sha1").update(data).digest("hex")
  hashedName = "#{hash[...12]}.#{filename}"
  newPath = path.join filedir, hashedName
  fs.renameSync filepath, newPath
  html = html.replace filename, hashedName

fs.writeFileSync HTML_PATH, html
