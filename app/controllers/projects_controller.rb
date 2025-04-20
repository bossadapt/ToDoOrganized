class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :user_is_owner, only: [ :edit, :update, :destroy ]
  before_action :user_is_apart_of_project, only: [ :show ]
  # GET /projects or /projects.json
  def index
    @projects = Project.joins(:users).where(users: { id: current_user.id })
    @focusedProject = nil
  end

  # GET /projects/1 or /projects/1.json
  def show
    @users = @project.users
    @current_id = current_user.id
    @current_fullname = current_user.full_name
    @actions = @project.actions
    @project_entries = @project.project_entries
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end
  def user_is_owner
    @project = Project.find_by(id: params[:id], owner: current_user)
    redirect_to projects_path, notice: "Only Owners are able to complete this task" if @project.nil?
  end
  def user_is_apart_of_project
    @project = Project.find(params[:id])
    redirect_to projects_path, notice: "Not apart of project" if !@project.users.include?(current_user)
  end
  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.owner= current_user
    @project.users=[ current_user ]
    @project.actions.push
    respond_to do |format|
      if @project.save
        @project.actions.create(
          author_id: current_user.id,
          author_fullname: current_user.full_name,
          action_type: "Create",
          description: @project.to_description
        )
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        @project.actions.create(
          author_id: current_user.id,
          author_fullname: current_user.full_name,
          action_type: "Edit",
          description: @project.to_description
        )
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, status: :see_other, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :title, :description ])
    end
end
