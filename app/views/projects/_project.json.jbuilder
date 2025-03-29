json.extract! project, :id, :owner_id, :title, :description, :created_at, :updated_at
json.url project_url(project, format: :json)
