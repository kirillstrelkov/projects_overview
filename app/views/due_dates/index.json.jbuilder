# frozen_string_literal: true

json.array! @due_dates, partial: 'due_dates/due_date', as: :due_date
