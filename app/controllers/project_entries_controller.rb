class ProjectEntriesController < ApplicationController
  before_action :set_project_entry, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :user_is_edit_able, only: [ :edit, :update, :destroy ]
  before_action :user_is_apart_of_project, only: [ :show, :edit, :update, :destroy, :index ]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  # GET /project_entries or /project_entries.json
  def index
      @project_entries = ProjectEntry.where(user: current_user)
  end

  # GET /project_entries/1 or /project_entries/1.json
  def show
    respond_to do |format|
      format.turbo_stream
      format.html { render :show, status: :ok, location: @project_entry }
      format.json { render :show, status: :ok, location: @project_entry }
    end
  end

  # GET /project_entries/new
  def new
    @project_entry = ProjectEntry.new
    @project_entry.project = Project.find_by(id: params[:project_id])
  end

  # GET /project_entries/1/edit
  def edit
    @project_entry = ProjectEntry.find(params[:id])
  end
  def user_is_edit_able
    # Check if the user is the author
    @project_entry = ProjectEntry.find_by(id: params[:id], author_id: current_user.id)
    # Check if the user is assigned
    if @project_entry.nil?
      @project_entry = ProjectEntry.find_by(id: params[:id], assigned_id: current_user.id)
    end
    # Check if the project entry is open for grabs
    if @project_entry.nil?
      @project_entry = ProjectEntry.find_by(id: params[:id], assigned_id: nil)
    end
    if @project_entry.nil?
      flash.now[:notice] = "Only Creator or Assigned can edit or delete this entry"
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
    end
  end
  def user_is_apart_of_project
    @project_entry = ProjectEntry.find(params[:id])
    # flash.now[:notice] = "Update successful"
    if !@project_entry.project.users.include?(current_user)
      redirect_to projects_path, notice: "Not apart of project"
    end
  end
  # POST /project_entries or /project_entries.json
  def create
    @project_entry = ProjectEntry.new(project_entry_params)
    @project_entry.author = current_user
    Rails.logger.debug "creation happening 123321"
    @project_entry.author_fullname = current_user.full_name
    if @project_entry.assigned.present?
      @project_entry.status = "assigned"
      @project_entry.assigned_id = @project_entry.assigned.id
      @project_entry.assigned_fullname = @project_entry.assigned.full_name
    else
      @project_entry.status = "new"
    end
    Rails.logger.debug @project_entry
    respond_to do |format|
      if @project_entry.save
        Rails.logger.debug "creation happening 123321"
        @project_entry.actions.create(
          author_id: current_user.id,
          targeting_project_entry: true,
          author_fullname: current_user.full_name,
          action_type: "Create",
          project_id: @project_entry.project.id,
          description: @project_entry.to_description
        )
        format.turbo_stream
        format.json { render :show, status: :created, location: @project_entry }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_project_entry",
            partial: "project_entries/form",
            locals: { project_entry: @project_entry }
          ), status: :bad_request
        end
        format.json { render json: @project_entry.errors, status: :bad_request }
      end
    end
  end

  # PATCH/PUT /project_entries/1 or /project_entries/1.json
  def update
    @action_type, @descriptionOfChange = "", ""
    safe_params = project_entry_params.to_h

    if safe_params[:status].present?
      handle_move_change(safe_params)
      if safe_params[:status] == "assigned"
        safe_params[:assigned_id] = current_user.id
      end
    else
      handle_edit_changes(safe_params)
    end
    if safe_params.key?(:assigned_id) && @project_entry.assigned_id.to_s != safe_params[:assigned_id].to_s
      handle_assigned_change(safe_params)
    end
    return if @descriptionOfChange.blank?

    respond_to do |format|
      if @project_entry.update(safe_params)
        @project_entry.actions.create(
          author_id: current_user.id,
          author_fullname: current_user.full_name,
          targeting_project_entry: true,
          action_type: @action_type,
          project_id: @project_entry.project.id,
          description: @descriptionOfChange
        )
        format.turbo_stream
        format.json { render :show, status: :ok, location: @project_entry }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "project_entry_update_form",
            partial: "project_entries/form_edit",
            locals: { project_entry: @project_entry }
          ), status: :bad_request
        end
        format.json { render json: @project_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_entries/1 or /project_entries/1.json
  def destroy
    @project_entry.comments.destroy_all
    @project_entry.actions.create(
      author_id: current_user.id,
      author_fullname: current_user.full_name,
      targeting_project_entry: true,
      action_type: "Delete",
      project_id: @project_entry.project.id,
      description: @project_entry.to_description
    )
    # possible refers
    # http://127.0.0.1:3000/todoorganized/project_entries/4
    # http://127.0.0.1:3000/todoorganized/projects/1
    # if its originating from a popup of a project
    @project_entry.destroy!
    if request.referer.include?("/projects/")
      respond_to do |format|
        format.turbo_stream
        format.json { head :no_content }
      end
    else
      Rails.logger.debug "Redirecting to project path: #{project_path(@project_entry.project)}"
      respond_to do |format|
        format.turbo_stream do
          redirect_to project_path(@project_entry.project), notice: "Project Entry was successfully destroyed."
        end
        format.json { head :no_content }
      end
    end
  end

  private
  def handle_move_change(safe_params)
    @action_type = "Move"
    @descriptionOfChange = "Moved from '#{@project_entry.status}' to '#{safe_params[:status]}'\n"
  end

  def handle_edit_changes(safe_params)
    @action_type = "Edit"

    track_field_change("Title", @project_entry.title, safe_params[:title])
    track_field_change("Description", @project_entry.description, safe_params[:description])
    track_field_change("Priority", @project_entry.priority.to_s, safe_params[:priority].to_s)
  end

  def track_field_change(label, old_val, new_val)
    return if old_val == new_val
    @descriptionOfChange += "#{label}: '#{old_val}' to '#{new_val}'\n"
  end

  def handle_assigned_change(safe_params)
    old_name = @project_entry.assigned_fullname.presence || "unassigned"
    new_name = safe_params[:assigned_fullname].presence || ""

    if safe_params[:assigned_id].present?
      user = User.find_by(id: safe_params[:assigned_id])
      new_name = user&.full_name || "Not Found"
      safe_params[:assigned_fullname] = new_name
    else
      safe_params[:assigned_fullname] = ""
      new_name = "unassigned"
    end

    old_str = "#{old_name}(#{@project_entry.assigned_id || ''})"
    new_str = "#{new_name}(#{safe_params[:assigned_id] || ''})"
    @descriptionOfChange += "Assigned: #{old_str} to #{new_str}\n"
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_project_entry
      @project_entry = ProjectEntry.find(params.expect(:id))
    end
    # TODO: fix this its broken, im trying to handle something being deleted inside the popup and then accessed from the actions
    def handle_record_not_found
      if request.referer.include?("/projects/")
        respond_to do |format|
          format.turbo_stream do
            flash.now[:notice] = "Project Entery never existed or no longer exists"
            render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
          end
          format.html do
            flash.now[:notice] = "Project Entery never existed or no longer exists"
            render :index
          end
          format.json do
            Rails.logger.debug "Project Entry not found and not handled by the referer"
            render json: { error: "Project Entry not found" }, status: :not_found
          end
        end
      else
        redirect_to projects_path, notice: "Project Entry never existed or no longer exists"
      end
      nil
    end
    # Only allow a list of trusted parameters through.
    def project_entry_params
      params.expect(project_entry: [ :id, :assigned_id, :project_id, :title, :priority, :description, :status ])
    end
end
