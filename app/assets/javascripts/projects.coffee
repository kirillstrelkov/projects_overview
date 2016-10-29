# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# FUNCTIONS
sort_dates = (dates)->
  dates.sort((a, b)->
    moment.utc(a).diff(moment.utc(b))
  )

format_project = (projects)->
  $(projects).each ()->
    project = $(this)
    timestamps = $.map(project.find('.bar-step'), (m)->
      get_timestamp(get_data(m, 'data-date'))
    )

    width = project.find('.progress').width()

    min_timestamp = Math.min.apply(null, timestamps)
    max_timestamp = Math.max.apply(null, timestamps)
    project.find('.bar-step').each (index)->
      timestamp = get_timestamp(get_data(this, 'data-date'))
      shift = (timestamp - min_timestamp) / (max_timestamp - min_timestamp) * width
      if shift == width
        text_width = $(this).find('.bar-text').width()
        shift = shift - text_width
      $(this).css('margin-left', shift + 'px')

get_data = (obj, key)->
  $(obj).attr(key)

get_js_date = (text)->
  moment(text).toDate()

get_timestamp = (date_string)->
  Date.parse(date_string.replace(' UTC', 'Z'))

init = ->
  format_project($('.project'))
  $('.datetimepicker').each( ->
    init_val = $(this).attr('value')
    $(this).datetimepicker({
      locale: navigator.language || navigator.userLanguage,
    })
    $(this).data("DateTimePicker").date(moment(init_val))
  )

# INIT
init()

# EVENTS
$(document).on 'click', '#add_due_date', (event)->
  $('#model_add_due_date').modal()
  init()

$(document).on 'click', '#modal_generate_dates', (event)->
  data = []
  modal = $('#model_add_due_date')
  start_date = moment(modal.find('#start_date').val())
  end_date = moment(modal.find('#end_date').val())
  freq = modal.find('#frequency').val()

  # if freq == 'weekly'
  subtract_time = 7

  new_dates = [start_date]
  new_date = moment(end_date)
  for i in [0...356]
    new_date.subtract(subtract_time, 'days')
    if new_date.isBetween(start_date, end_date)
      new_dates.push(moment(new_date))
    else
      break

  new_dates.push(end_date)
  $.each(new_dates, (i)->
    date = this.toString()
    progress = (this - start_date) / (end_date - start_date) * 100
    data.push({
      due_date: moment.utc(this).toString(),
      progress: progress,
    })
  )

  link = $(this).parent().find('input[name*="link"]').val()
  $.get(link, data: data).done((resp)->
    $('#dates_table tbody').replaceWith($(resp).find('tbody'))
    $('#model_add_due_date').modal('hide')
    init()
  )
