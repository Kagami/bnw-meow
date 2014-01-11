#!node_modules/.bin/coffee

# For some reason npm(1) doesn't provide such functionality.
config = require "./package.json"
console.log config.version
