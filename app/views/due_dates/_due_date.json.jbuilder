# frozen_string_literal: true

json.extract! due_date, :id, :name, :description, :date, :progress, :project_id, :created_at, :updated_at
json.url due_date_url(due_date, format: :json)
