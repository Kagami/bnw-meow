define [
  "pikaday"
  "views/base/view"
], (Pikaday, View) ->
  "use strict"

  class DatePickerView extends View

    initialize: (options) ->
      super options
      @picker = new Pikaday
        field: @el
        firstDay: 1
        format: "DD/MM/YYYY"
        yearRange: [2006, 2020]
        i18n:
          months:
            ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь",
             "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
          weekdays:
            ["Воскресенье", "Понедельник", "Вторник", "Среда",
             "Четверг", "Пятница", "Суббота"]
          weekdaysShort:
            ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
        onSelect: =>
          @trigger "change", @picker.getMoment()

    show: ->
      @picker.show()

    hide: ->
      @picker.hide()
