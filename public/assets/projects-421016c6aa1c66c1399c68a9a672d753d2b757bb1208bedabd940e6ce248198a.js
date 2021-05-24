(function() {
  var format_datetime_to_local, format_projects, get_data, get_progress, get_project_data, get_timestamp, init, init_datetimepickers, init_popovers, round, sort_dates, update_progress_bars;

  sort_dates = function(dates) {
    return dates.sort(function(a, b) {
      return moment.utc(a).diff(moment.utc(b));
    });
  };

  format_projects = function() {
    return $('.project').each(function() {
      var max_timestamp, min_timestamp, project, timestamps, width;
      project = $(this);
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
    });
  };

  get_data = function(obj, key) {
    return $(obj).attr(key);
  };

  get_timestamp = function(date_string) {
    return Date.parse(date_string.replace(' UTC', 'Z'));
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

  update_progress_bars = function(project) {
    var current_datetime, current_progress, expected_datetime, expected_progress, progress_diff, steps;
    current_datetime = moment();
    current_progress = parseFloat($(project).find('.progress-bar.positive span').text());
    expected_datetime = null;
    expected_progress = null;
    steps = $(project).find('.bar-step');
    steps.each(function() {
      var datetime;
      datetime = moment($(this).data('date'));
      if (datetime.isSameOrBefore(current_datetime)) {
        expected_datetime = datetime;
        return expected_progress = $(this).data('progress');
      } else {
        return false;
      }
    });
    expected_progress = get_progress(moment($(steps[0]).data('date')), current_datetime, moment($(steps[steps.length - 1]).data('date')));
    progress_diff = round(expected_progress - current_progress);
    if (progress_diff > 100.0) {
      progress_diff = round(100.0 - current_progress);
    }
    $(project).find('.progress-bar.negative span').text(progress_diff + "%");
    return $(project).find('.progress-bar.negative').width(progress_diff + "%");
  };

  init_datetimepickers = function() {
    return $('.datetimepicker').each(function() {
      var empty, init_val;
      init_val = $(this).attr('value');
      empty = init_val === '';
      if (moment(init_val, moment.ISO_8601).isValid() || empty) {
        $(this).datetimepicker({
          locale: navigator.language || navigator.userLanguage
        });
        $(this).addClass('formatted');
        return $(this).data("DateTimePicker").date(empty ? moment() : moment(init_val));
      }
    });
  };

  format_datetime_to_local = function(parent) {
    var dateFormat, datetime_format, localeData, timeFormat;
    parent = parent === void 0 ? $('body') : $(parent);
    localeData = moment.localeData();
    dateFormat = localeData.longDateFormat('L');
    timeFormat = localeData.longDateFormat('LT');
    datetime_format = dateFormat + " " + timeFormat;
    return parent.find('.datetime').each(function() {
      return $(this).text(moment($(this).text().trim()).format(datetime_format));
    });
  };

  get_project_data = function() {
    return $('.project').map(function() {
      var project;
      project = $(this);
      return {
        content: project.prop('outerHTML'),
        start: moment(project.find('.bar-step').first().data('date')),
        end: moment(project.find('.bar-step').last().data('date'))
      };
    });
  };

  init_popovers = function() {
    var popovers;
    popovers = $('[data-toggle="popover"]');
    popovers.popover({
      html: true,
      container: "body",
      placement: "bottom"
    });
    return popovers.each(function() {
      return $(this).on('shown.bs.popover', function() {
        return format_datetime_to_local('.popover');
      });
    });
  };

  init = function() {
    var container, data, options, timeline, viz;
    if (window.location.href.indexOf('projects') === -1) {
      return;
    }
    init_popovers();
    init_datetimepickers();
    format_datetime_to_local();
    format_projects();
    viz = $('#visualization');
    if (viz.length > 0 && viz.children().length === 0) {
      container = viz[0];
      data = get_project_data().toArray();
      options = {
        zoomable: false,
        start: moment().subtract(1, 'months'),
        end: moment().add(1, 'months'),
        selectable: false
      };
      timeline = new vis.Timeline(container, data, options);
      return timeline.on('changed', function(event) {
        $('.vis-item').each(function() {
          var item;
          item = $(this);
          if (parseFloat(item.css('left')) < 0) {
            return item.find('.vis-item-content').css('left', '0');
          }
        });
        return format_projects();
      });
    }
  };

  $(document).on("turbolinks:load", function() {
    return init();
  });

  $(document).ready(function() {
    return init();
  });

  $(document).on('click', '#project_save', function(event) {
    return $('.datetimepicker').each(function() {
      var value;
      value = $(this).attr('value');
      return $(this).val(value);
    });
  });

  $(document).on('click', '#add_due_date', function(event) {
    $('#model_add_due_date').modal();
    return init();
  });

  $(document).on('click', '#modal_generate_dates', function(event) {
    var data, end_date, freq, i, j, link, modal, new_date, new_dates, start_date, subtract_time;
    data = [];
    modal = $('#model_add_due_date');
    start_date = moment(modal.find('#start_date').val());
    end_date = moment(modal.find('#end_date').val());
    freq = modal.find('#frequency').val();
    subtract_time = 7;
    new_dates = [start_date];
    new_date = moment(end_date);
    for (i = j = 0; j < 356; i = ++j) {
      new_date.subtract(subtract_time, 'days');
      if (new_date.isBetween(start_date, end_date)) {
        new_dates.push(moment(new_date));
      } else {
        break;
      }
    }
    new_dates.push(end_date);
    $.each(new_dates, function(i) {
      var date, progress;
      date = this.toString();
      progress = get_progress(start_date, this, end_date);
      return data.push({
        due_date: moment.utc(this).toString(),
        progress: progress
      });
    });
    link = $(this).parent().find('input[name*="link"]').val();
    return $.post(link, {
      data: data
    }).done(function(resp) {
      $('#dates_table tbody').replaceWith($(resp).find('tbody'));
      $('#model_add_due_date').modal('hide');
      return init();
    });
  });

}).call(this);
