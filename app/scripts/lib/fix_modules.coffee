# Provide ability to load some vendor libraries via CommonJS require.
window.require.define
  moment: (require, exports, module) ->
    module.exports = window.moment

  tinycon: (require, exports, module) ->
    module.exports = window.Tinycon

  marked: (require, exports, module) ->
    module.exports = window.marked

  highlight: (require, exports, module) ->
    module.exports = window.hljs

  pikaday: (require, exports, module) ->
    module.exports = window.Pikaday
