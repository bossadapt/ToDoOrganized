json.extract! project_entry, :id, :id, :creator_id, :creator_fullname, :assigned_id, :assigned_fullname, :project_id, :title, :priority, :description, :status, :created_at, :updated_at
json.url project_entry_url(project_entry, format: :json)
