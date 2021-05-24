# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
getTrelloToken = ->
  token = Cookies.get('token')
  if (!!token)
    return token

  if (!!window.location.hash)
    key_value = window.location.hash.substring(1).split('=')
    if (key_value[0] == 'token')
      return key_value[1]


addBoards = (boards)->
  selectElement = document.getElementById('boardSelect')
  if selectElement.disabled
    selectElement.disabled = false
  while selectElement.length > 0
    selectElement.remove(0)

  for board, i in boards
    selectElement.add(new Option(board['name'], board['id']))

loadBoards = (resp)->
  token = getTrelloToken()
  window.Trello.get(
    '/members/me/boards', 
    {'token': token, 'filter': 'open'}
    (resp) ->
      addBoards(resp)
  )

drawCard = (card, progressValue)->
  if progressValue < 1
    progressValue = progressValue * 100

  url = card.shortUrl
  startDate = card.start
  endDate = card.due
  if isUndefined(startDate) || isUndefined(endDate)
    return

  momentStartDate = moment(startDate)
  momentEndDate = moment(endDate)
  dateOnly = momentEndDate.diff(momentStartDate, 'days') < 14
  formattedStartDate = formatDatetime(momentStartDate, dateOnly)
  formattedEndDate = formatDatetime(momentEndDate, dateOnly)

  content = """
<div class="panel panel-default card" id="#{card.id}">
  <div class="panel-heading">
    <h3 class="panel-title">
      <a href="#{url}" target="_blank">#{card.name}</a>
    </h3>
  </div>
  <div class="panel-body">
    <div class="progress" data-date-start="#{startDate}" data-date-end="#{endDate}">
      <div class="progress-bar progress-bar-success positive" role="progressbar" style="width: #{progressValue}%;">
        <span>
        #{progressValue}%
        </span>
      </div>
      <div class="progress-bar progress-bar-danger negative" role="progressbar" style="width: 0.0%;">
        <span></span>
      </div>
    </div>
  </div>
  <div class="panel-footer">
    <span class="start-date"> 
      #{formattedStartDate}
    </span>
    <span class="end-date"> 
      #{formattedEndDate}
    </span>
  </div>
</div>
"""

  window.visDataSet.add({
      id: card.id,
      content: content,
      start: moment(startDate),
      end: moment(endDate)
    })

populateProgressField = (card, progressFieldId)->
  progressFields = card.customFieldItems.filter((field)=> field.idCustomField == progressFieldId)

  if progressFields.length > 0
    progressValue = parseFloat(progressFields[0].value.number)
  else
    progressValue = 0

  drawCard(card, progressValue)


loadCards = (cards, customFields)->
  progressFields  = customFields.filter((field)=> field.name == 'progress')
  if progressFields.length > 0
    progressFieldId = progressFields[0].id
  else
    progressFieldId = undefined

  for card, i in cards
    trelloWrapper(
      "/cards/#{card.id}", 
      {'customFieldItems': true},
      (card)=> populateProgressField(card, progressFieldId)
    )

isUndefined = (obj)-> 
  return  !obj


trelloWrapper = (url, params=undefined, func=undefined)->
  if isUndefined(func)
    func = params
    params = undefined

  if isUndefined(params)
    params = {}

  params['token'] = getTrelloToken()
  window.Trello.get(
    url,     
    params,
    func
  )


loadTimeline = ->
  window.visDataSet.clear()
  boardId = document.getElementById('boardSelect').value
  
  trelloWrapper(
    "/boards/#{boardId}/customFields", 
    (customFields)->
      trelloWrapper(
        "/boards/#{boardId}/cards", 
        (cards)-> loadCards(cards, customFields)
      )
  )

$(document).ready ->
  if window.location.href.indexOf('/trello') == -1
    return
  
  visInit()

$(document).on 'click', '#load-timline', (event)->
  token = getTrelloToken()
  if (!token)
    window.Trello.authorize(
      name: "Trello timeline", 
      scope: { read: true, write: false, account: false },
      success: loadBoards
    )
  else
    loadBoards()

$(document).on 'input', '#boardSelect', (event)->
  loadTimeline()


# ---------------------------------------------
visOnAdd = (event, properties, senderId)->
  for id, i in properties.items
    setTimeout (-> format_project(id)), 1000

visInit = ()->
  window.visDataSet = new vis.DataSet()
  window.visDataSet.on(
    'add', 
    visOnAdd
  )

  viz = $('#visualization')
  if viz.length > 0 and viz.children().length == 0
    container = viz[0]
    options = {
      zoomable: false,
      start: moment().subtract(1, 'months'),
      end: moment().add(1, 'months'),
      selectable: false,
    }
    visTimeline = new vis.Timeline(container, window.visDataSet, options)


formatDatetime = (datetime, dateOnly=false)->
  localeData = moment.localeData()
  dateFormat = localeData.longDateFormat('L')
  if dateOnly
    datetime_format = "#{dateFormat}"
  else
    timeFormat = localeData.longDateFormat('LT')
    datetime_format = "#{dateFormat} #{timeFormat}"

  datetime.format(datetime_format)


format_projects = (id)->
  window.visDataSet.forEach(format_project);


format_project = (id)->
  project = $("##{id}")

  start_datetime = moment($(project).find('.progress').data('date-start'))
  end_datetime = moment($(project).find('.progress').data('date-end'))

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

update_progress_bars = (project)->
  current_datetime = moment()
  current_progress = parseFloat($(project).find('.progress-bar.positive span').text())
  start_datetime = moment($(project).find('.progress').data('date-start'))
  end_datetime = moment($(project).find('.progress').data('date-end'))
  expected_progress = get_progress(
    start_datetime,
    current_datetime,
    end_datetime,
  )
  progress_diff = round(expected_progress - current_progress)
  progress_diff = round(100.0 - current_progress) if progress_diff > 100.0
  $(project).find('.progress-bar.negative span').text("#{progress_diff}%")
  $(project).find('.progress-bar.negative').width("#{progress_diff}%")

round = (number)->
  Math.round(number * 100) / 100

get_progress = (start, current, end)->
  if start.isBefore(end)
    round((current - start) / (end - start) * 100)
  else
    0.0

get_timestamp = (date_string)->
  Date.parse(date_string.replace(' UTC', 'Z'))

get_data = (obj, key)->
  $(obj).attr(key)
