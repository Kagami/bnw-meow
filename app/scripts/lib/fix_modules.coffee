# Provide ability to load some vendor libraries via CommonJS require.
window.require.define
  moment: (require, exports, module) ->
    module.exports = moment
  tinycon: (require, exports, module) ->
    module.exports = Tinycon
  marked: (require, exports, module) ->
    module.exports = marked
  highlight: (require, exports, module) ->
    module.exports = hljs
