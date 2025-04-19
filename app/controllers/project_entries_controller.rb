class ProjectEntriesController < ApplicationController
  before_action :set_project_entry, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :user_is_edit_able, only: [ :edit, :update, :destroy ]
  before_action :user_is_apart_of_project, only: [ :show, :edit, :update, :destroy ]
  # GET /project_entries or /project_entries.json
  def index
      @project_entries = ProjectEntry.where(user: current_user)
  end

  # GET /project_entries/1 or /project_entries/1.json
  def show
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
    @project_entry = ProjectEntry.where(id: params[:id])
    .where("author_id = :user_id OR assigned_id = :user_id", user_id: current_user.id)
    .first
    if @project_entry.nil?
      Rails.logger.error "User tried to edit an item that it was not the author or asignee to"
      redirect_to projects_path, notice: "Only Creator or Assigned are able to edit this entryt"
    end
  end
  def user_is_apart_of_project
    @project_entry = ProjectEntry.find(params[:id])
    # flash.now[:notice] = "Update successful"
    if !@project_entry.project.users.include?(current_user)
      Rails.logger.error "User tried to see something when not apart of project"
      redirect_to projects_path, notice: "Not apart of project"
    end
  end
  # POST /project_entries or /project_entries.json
  def create
    @project_entry = ProjectEntry.new(project_entry_params)
    @project_entry.author = current_user
    # Rails.logger.debug @project_id
    # @project_entry.project = @project_id
    @project_entry.author_fullname = current_user.full_name
    if @project_entry.assigned.nil?
      @project_entry.status = "new"
    else
      @project_entry.status = "assigned"
      @project_entry.assigned_id = @project_entry.assigned.id
      @project_entry.assigned_fullname = @project_entry.assigned.full_name
    end
    respond_to do |format|
      if @project_entry.save
        format.turbo_stream
        format.json { render :show, status: :created, location: @project_entry }
      else
        format.turbo_stream
        format.json { render json: @project_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_entries/1 or /project_entries/1.json
  def update
    Rails.logger.debug "Rails UPDATER CALLED"
    Rails.logger.debug @project_entry
    Rails.logger.debug project_entry_params
    respond_to do |format|
      if @project_entry.update(project_entry_params)
        format.turbo_stream
        format.json { render :show, status: :ok, location: @project_entry }
      else
        Rails.logger.debug "errors found:"
        Rails.logger.debug @project_entry.errors
        format.turbo_stream
        format.json { render json: @project_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_entries/1 or /project_entries/1.json
  def destroy
    @project_entry.destroy!

    respond_to do |format|
      format.turbo_stream
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_entry
      @project_entry = ProjectEntry.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def project_entry_params
      params.expect(project_entry: [ :id, :creator_id, :creator_fullname, :assigned_id, :assigned_fullname, :project_id, :title, :priority, :description, :status ])
    end
end
