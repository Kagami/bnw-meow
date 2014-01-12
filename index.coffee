#!node_modules/.bin/coffee

STATIC_DIR = "public/static"
HTML_PATH = "public/index.html"

fs = require "fs"
path = require "path"
crypto = require "crypto"

html = fs.readFileSync HTML_PATH, encoding: "utf-8"

readDir = (dir) ->
  files = fs.readdirSync(dir)
  files.filter (filename) ->
    filename[-3..] is ".js" or
    filename[-4..] is ".css"
  .map (filename) ->
    name: filename
    path: path.join dir, filename
    dir: dir

for file in readDir(STATIC_DIR)
  data = fs.readFileSync file.path
  hash = crypto.createHash("sha1").update(data).digest("hex")
  hashedName = "#{hash[...12]}.#{file.name}"
  newPath = path.join file.dir, hashedName
  fs.renameSync file.path, newPath
  html = html.replace file.name, hashedName

fs.writeFileSync HTML_PATH, html
