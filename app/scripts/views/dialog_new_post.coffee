$ = require "jquery"
_ = require "underscore"
DialogView = require "views/base/dialog"
ViewHelpers = require "lib/view_helpers"
utils = require "lib/utils"
template = require "templates/dialog_new_post"
formatters = require "lib/formatters"

module.exports = class DialogNewPostView extends DialogView
  container: "body"
  template: template
  events:
    "click #post-form-submit": "post"
    "keypress #post-form-text": "keypress"

  afterRender: ->
    super
    @$("[data-toggle='tab']").on "show shown", (e) ->
      e.stopPropagation()

    @$('#post-form-tabs [href="#post-form-preview"]').on 'show', (e) ->
      formattedText = formatters.format $('#post-form-text').val(), 'markdown'

      htmlI = (c) ->
        v = $('<i/>').addClass(c)
        v[0]

      htmlA = (h,t,c) ->
        v = $('<a/>').addClass(c).attr('href',h).text(t)
        v[0]

      htmlDiv = (c,h) ->
        v = $('<div/>').addClass(c).html(h)
        v[0]

      textNode = (t) ->
        document.createTextNode t

      insertCommas = ( a ) ->
        return a if a.length < 1
        result = [ a[0] ]
        for v in a[1..]
          result.push textNode ', '
          result.push v
        result

      splitTrimFilter = (t,s) ->
        ( e.trim() for e in t.split s ).filter (e) ->
          return e.length > 0

      tags = splitTrimFilter $('#post-form-tags').val(), ','
      clubs = splitTrimFilter $('#post-form-clubs').val(), ','

      tagsNodes = []
      if tags.length > 0
        tagsNodes = ( htmlA '/t/' + e, e, 'post-tag' for e in tags )
        tagsNodes = insertCommas tagsNodes
        tagsNodes.unshift htmlI('icon-tags'), textNode ' '

      clubsNodes = []
      if clubs.length > 0
        clubsNodes = ( htmlA '/c/' + e, e, 'post-club' for e in clubs )
        clubsNodes = insertCommas clubsNodes
        clubsNodes.unshift htmlI('icon-group'), textNode ' '
        if tags.length > 0
          clubsNodes.unshift textNode ' '

      postBody = htmlDiv "post-body", formattedText

      footer = htmlDiv "post-footer", ''
      footer.appendChild e for e in tagsNodes
      footer.appendChild e for e in clubsNodes

      preview = $('#post-form-preview')
      preview.html ''
      preview.append postBody
      preview.append footer

    @modal.on "shown", =>
      $('#post-form-tabs [href="#post-form-edit"]').tab('show')
      $("#post-form-text").focus()

  post: ->
    return unless utils.isLogged()

    textarea = $("#post-form-text")
    inputTags = $("#post-form-tags")
    inputClubs = $("#post-form-clubs")

    splitTrimFilter = (t,s) ->
      ( e.trim() for e in t.split s ).filter (e) ->
        return e.length > 0

    tags = splitTrimFilter inputTags.val(), ','
    clubs = splitTrimFilter inputClubs.val(), ','
    text = textarea.val()

    clubs = if clubs.length then clubs.join "," else undefined
    tags = if tags.length then tags.join "," else undefined

    submit = $("#post-form-submit").prop("disabled", true)
    cancel = $("#post-form-cancel").prop("disabled", true)
    i = submit.children("i").toggleClass("icon-refresh icon-spin")

    anonymous = ViewHelpers.getAnonymousModeStatus()

    d = utils.post "post", {tags, clubs, text, anonymous}
    d.always ->
      submit.prop("disabled", false)
      cancel.prop("disabled", false)
      i.toggleClass("icon-refresh icon-spin")
    d.done (data) =>
      textarea.val("")
      inputTags.val("")
      inputClubs.val("")
      @hide()
      utils.gotoUrl "/p/#{data.id}"

  keypress: (e) ->
    if e.ctrlKey and (e.keyCode == 13 or e.keyCode == 10)
      # FIXME: Should we use some instance variable for check
      # is we already sending message?
      unless $("#post-form-submit").prop("disabled")
        @post()
