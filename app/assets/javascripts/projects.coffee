# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# FUNCTIONS
sort_dates = (dates)->
  dates.sort((a, b)->
    moment.utc(a).diff(moment.utc(b))
  )

format_projects = ->
  $('.project').each ()->
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

    update_progress_bars(project)

get_data = (obj, key)->
  $(obj).attr(key)

get_js_date = (text)->
  moment(text).toDate()

get_timestamp = (date_string)->
  Date.parse(date_string.replace(' UTC', 'Z'))

round = (number)->
  Math.round(number * 100) / 100

get_progress = (start, current, end)->
  if start.isBefore(end)
    progress = (current - start) / (end - start) * 100
    Math.round(progress * 100) / 100
  else
    0.0

update_progress_bars = (project)->
  current_datetime = $('#hidden_datetime').data('DateTimePicker').date()
  current_progress = parseFloat($(project).find('.progress-bar.positive span').text())
  expected_datetime = null
  expected_progress = null
  steps = $(project).find('.bar-step')
  steps.each ->
    datetime = moment($(this).data('date'))

    if datetime.isSameOrBefore(current_datetime)
      expected_datetime = datetime
      expected_progress = $(this).data('progress')
    else
      false
  expected_progress = get_progress(
    moment($(steps[0]).data('date')),
    current_datetime,
    moment($(steps[steps.length-1]).data('date')),
  )
  progress_diff = round(expected_progress - current_progress)
  progress_diff = round(100.0 - current_progress) if progress_diff > 100.0
  $(project).find('.progress-bar.negative span').text("#{progress_diff}%")
  $(project).find('.progress-bar.negative').width("#{progress_diff}%")

init_datetimepickers = ->
  $('.datetimepicker').each ->
    init_val = $(this).attr('value')
    $(this).datetimepicker({
      locale: navigator.language || navigator.userLanguage,
    })
    $(this).data("DateTimePicker").date(moment(init_val))

format_datetime_to_local = ->
  ldf = $('#hidden_datetime').data('DateTimePicker').date()._locale._longDateFormat
  datetime_format = "#{ldf.L} #{ldf.LT}"
  $('.datetime').each ->
    $(this).text(moment($(this).text()).format(datetime_format))

init = ->
  init_datetimepickers()
  format_datetime_to_local() # should be called before format projects
  format_projects()

# INIT
$(document).ready ->
  init()

# EVENTS
$(document).on "turbolinks:load", ->
  init()

$(document).on 'click', '#project_save', (event)->
  $('.datetimepicker').each ->
    value = $(this).attr('value')
    $(this).val(value)

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
    progress = get_progress(start_date, this, end_date)
    data.push({
      due_date: moment.utc(this).toString(),
      progress: progress,
    })
  )

  link = $(this).parent().find('input[name*="link"]').val()
  $.post(link, data: data).done((resp)->
    $('#dates_table tbody').replaceWith($(resp).find('tbody'))
    $('#model_add_due_date').modal('hide')
    init()
  )
