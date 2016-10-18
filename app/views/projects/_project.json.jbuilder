json.extract! project, :id, :name, :description, :current_progress, :created_at, :updated_at
json.url project_url(project, format: :json)