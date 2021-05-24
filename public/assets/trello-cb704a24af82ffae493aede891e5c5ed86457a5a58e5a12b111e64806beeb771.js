(function() {
  var addBoards, drawCard, formatDatetime, format_project, format_projects, getTrelloToken, get_data, get_progress, get_timestamp, isUndefined, loadBoards, loadCards, loadTimeline, populateProgressField, round, trelloWrapper, update_progress_bars, visInit, visOnAdd;

  getTrelloToken = function() {
    var key_value, token;
    token = Cookies.get('token');
    if (!!token) {
      return token;
    }
    if (!!window.location.hash) {
      key_value = window.location.hash.substring(1).split('=');
      if (key_value[0] === 'token') {
        return key_value[1];
      }
    }
  };

  addBoards = function(boards) {
    var board, i, j, len, results, selectElement;
    selectElement = document.getElementById('boardSelect');
    if (selectElement.disabled) {
      selectElement.disabled = false;
    }
    while (selectElement.length > 0) {
      selectElement.remove(0);
    }
    results = [];
    for (i = j = 0, len = boards.length; j < len; i = ++j) {
      board = boards[i];
      results.push(selectElement.add(new Option(board['name'], board['id'])));
    }
    return results;
  };

  loadBoards = function(resp) {
    var token;
    token = getTrelloToken();
    return window.Trello.get('/members/me/boards', {
      'token': token,
      'filter': 'open'
    }, function(resp) {
      return addBoards(resp);
    });
  };

  drawCard = function(card, progressValue) {
    var content, dateOnly, endDate, formattedEndDate, formattedStartDate, momentEndDate, momentStartDate, startDate, url;
    if (progressValue < 1) {
      progressValue = progressValue * 100;
    }
    url = card.shortUrl;
    startDate = card.start;
    endDate = card.due;
    if (isUndefined(startDate) || isUndefined(endDate)) {
      return;
    }
    momentStartDate = moment(startDate);
    momentEndDate = moment(endDate);
    dateOnly = momentEndDate.diff(momentStartDate, 'days') < 14;
    formattedStartDate = formatDatetime(momentStartDate, dateOnly);
    formattedEndDate = formatDatetime(momentEndDate, dateOnly);
    content = "<div class=\"panel panel-default card\" id=\"" + card.id + "\">\n  <div class=\"panel-heading\">\n    <h3 class=\"panel-title\">\n      <a href=\"" + url + "\" target=\"_blank\">" + card.name + "</a>\n    </h3>\n  </div>\n  <div class=\"panel-body\">\n    <div class=\"progress\" data-date-start=\"" + startDate + "\" data-date-end=\"" + endDate + "\">\n      <div class=\"progress-bar progress-bar-success positive\" role=\"progressbar\" style=\"width: " + progressValue + "%;\">\n        <span>\n        " + progressValue + "%\n        </span>\n      </div>\n      <div class=\"progress-bar progress-bar-danger negative\" role=\"progressbar\" style=\"width: 0.0%;\">\n        <span></span>\n      </div>\n    </div>\n  </div>\n  <div class=\"panel-footer\">\n    <span class=\"start-date\"> \n      " + formattedStartDate + "\n    </span>\n    <span class=\"end-date\"> \n      " + formattedEndDate + "\n    </span>\n  </div>\n</div>";
    return window.visDataSet.add({
      id: card.id,
      content: content,
      start: moment(startDate),
      end: moment(endDate)
    });
  };

  populateProgressField = function(card, progressFieldId) {
    var progressFields, progressValue;
    progressFields = card.customFieldItems.filter((function(_this) {
      return function(field) {
        return field.idCustomField === progressFieldId;
      };
    })(this));
    if (progressFields.length > 0) {
      progressValue = parseFloat(progressFields[0].value.number);
    } else {
      progressValue = 0;
    }
    return drawCard(card, progressValue);
  };

  loadCards = function(cards, customFields) {
    var card, i, j, len, progressFieldId, progressFields, results;
    progressFields = customFields.filter((function(_this) {
      return function(field) {
        return field.name === 'progress';
      };
    })(this));
    if (progressFields.length > 0) {
      progressFieldId = progressFields[0].id;
    } else {
      progressFieldId = void 0;
    }
    results = [];
    for (i = j = 0, len = cards.length; j < len; i = ++j) {
      card = cards[i];
      results.push(trelloWrapper("/cards/" + card.id, {
        'customFieldItems': true
      }, (function(_this) {
        return function(card) {
          return populateProgressField(card, progressFieldId);
        };
      })(this)));
    }
    return results;
  };

  isUndefined = function(obj) {
    return !obj;
  };

  trelloWrapper = function(url, params, func) {
    if (params == null) {
      params = void 0;
    }
    if (func == null) {
      func = void 0;
    }
    if (isUndefined(func)) {
      func = params;
      params = void 0;
    }
    if (isUndefined(params)) {
      params = {};
    }
    params['token'] = getTrelloToken();
    return window.Trello.get(url, params, func);
  };

  loadTimeline = function() {
    var boardId;
    window.visDataSet.clear();
    boardId = document.getElementById('boardSelect').value;
    return trelloWrapper("/boards/" + boardId + "/customFields", function(customFields) {
      return trelloWrapper("/boards/" + boardId + "/cards", function(cards) {
        return loadCards(cards, customFields);
      });
    });
  };

  $(document).ready(function() {
    if (window.location.href.indexOf('/trello') === -1) {
      return;
    }
    return visInit();
  });

  $(document).on('click', '#load-timline', function(event) {
    var token;
    token = getTrelloToken();
    if (!token) {
      return window.Trello.authorize({
        name: "Trello timeline",
        scope: {
          read: true,
          write: false,
          account: false
        },
        success: loadBoards
      });
    } else {
      return loadBoards();
    }
  });

  $(document).on('input', '#boardSelect', function(event) {
    return loadTimeline();
  });

  visOnAdd = function(event, properties, senderId) {
    var i, id, j, len, ref, results;
    ref = properties.items;
    results = [];
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      id = ref[i];
      results.push(setTimeout((function() {
        return format_project(id);
      }), 1000));
    }
    return results;
  };

  visInit = function() {
    var container, options, visTimeline, viz;
    window.visDataSet = new vis.DataSet();
    window.visDataSet.on('add', visOnAdd);
    viz = $('#visualization');
    if (viz.length > 0 && viz.children().length === 0) {
      container = viz[0];
      options = {
        zoomable: false,
        start: moment().subtract(1, 'months'),
        end: moment().add(1, 'months'),
        selectable: false
      };
      return visTimeline = new vis.Timeline(container, window.visDataSet, options);
    }
  };

  formatDatetime = function(datetime, dateOnly) {
    var dateFormat, datetime_format, localeData, timeFormat;
    if (dateOnly == null) {
      dateOnly = false;
    }
    localeData = moment.localeData();
    dateFormat = localeData.longDateFormat('L');
    if (dateOnly) {
      datetime_format = "" + dateFormat;
    } else {
      timeFormat = localeData.longDateFormat('LT');
      datetime_format = dateFormat + " " + timeFormat;
    }
    return datetime.format(datetime_format);
  };

  format_projects = function(id) {
    return window.visDataSet.forEach(format_project);
  };

  format_project = function(id) {
    var end_datetime, max_timestamp, min_timestamp, project, start_datetime, timestamps, width;
    project = $("#" + id);
    start_datetime = moment($(project).find('.progress').data('date-start'));
    end_datetime = moment($(project).find('.progress').data('date-end'));
    timestamps = $.map(project.find('.bar-step'), function(m) {
      return get_timestamp(get_data(m, 'data-date'));
    });
    width = project.find('.progress').width();
    min_timestamp = Math.min.apply(null, timestamps);
    max_timestamp = Math.max.apply(null, timestamps);
    project.find('.bar-step').each(function(index) {
      var shift, text_width, timestamp;
      timestamp = get_timestamp(get_data(this, 'data-date'));
      shift = (timestamp - min_timestamp) / (max_timestamp - min_timestamp) * width;
      if (shift === width) {
        text_width = $(this).find('.bar-text').width();
        shift = shift - text_width;
      }
      return $(this).css('margin-left', shift + 'px');
    });
    return update_progress_bars(project);
  };

  update_progress_bars = function(project) {
    var current_datetime, current_progress, end_datetime, expected_progress, progress_diff, start_datetime;
    current_datetime = moment();
    current_progress = parseFloat($(project).find('.progress-bar.positive span').text());
    start_datetime = moment($(project).find('.progress').data('date-start'));
    end_datetime = moment($(project).find('.progress').data('date-end'));
    expected_progress = get_progress(start_datetime, current_datetime, end_datetime);
    progress_diff = round(expected_progress - current_progress);
    if (progress_diff > 100.0) {
      progress_diff = round(100.0 - current_progress);
    }
    $(project).find('.progress-bar.negative span').text(progress_diff + "%");
    return $(project).find('.progress-bar.negative').width(progress_diff + "%");
  };

  round = function(number) {
    return Math.round(number * 100) / 100;
  };

  get_progress = function(start, current, end) {
    if (start.isBefore(end)) {
      return round((current - start) / (end - start) * 100);
    } else {
      return 0.0;
    }
  };

  get_timestamp = function(date_string) {
    return Date.parse(date_string.replace(' UTC', 'Z'));
  };

  get_data = function(obj, key) {
    return $(obj).attr(key);
  };

}).call(this);
