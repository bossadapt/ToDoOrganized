class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy generate_invite use_invite]
  before_action :authenticate_user!
  before_action :user_is_owner, only: [ :edit, :update, :destroy, :generate_invite ]
  before_action :user_is_apart_of_project, only: [ :show ]
  # GET /projects or /projects.json
  def index
    @projects = Project.joins(:users).where(users: { id: current_user.id })
    @focusedProject = nil
  end

  # GET /projects/1 or /projects/1.json
  def show
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
    @project = Project.find_by(id: params[:id], owner_id: current_user.id)
    # TODO: Completed 500 Internal Server Error in 31ms (ActiveRecord: 3.5ms (3 queries, 0 cached) | GC: 1.1ms) for generating link
    if @project.nil?
      Rails.debugger "debug as inteded 555666"
      flash.now[:notice] = "Only the owner can edit, delete or generate invites for the project"
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
    end
  end
  def user_is_apart_of_project
    @project = Project.find(params[:id])
    redirect_to projects_path, notice: "Not apart of project" if !@project.users.include?(current_user)
  end
  def show_all_actions
    @project = Project.find(params[:id])
    @actions = @project.actions.ordered
    respond_to do |format|
      format.turbo_stream
    end
  end
  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.owner= current_user
    @project.users=[ current_user ]
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
  # GET /projects/1/generate-invite/
  def generate_invite
    code_generated = SecureRandom.uuid
    Rails.debugger "tried to debug despite it should have failed 555666"
    invite = @project.project_invites.create(
      link_code: code_generated,
      expiration: DateTime.now + 1
    )
    if invite.persisted?
      link_generated =  "#{request.base_url}/projects/#{@project.id}/use-invite/#{code_generated}"
      respond_to do |format|
        format.turbo_stream
        format.json { render json: { link: link_generated } }
      end
    else
      head :unprocessable_entity
    end
  end
  # GET /projects/1/use-invite/123423-234asdf34-234234-2asdf4
  def use_invite
    @project = Project.find(params[:id])
    invite_code = params[:invite_code]
    project_invite = @project.project_invites.find_by(link_code: invite_code)
    if project_invite.present? && project_invite.expiration > DateTime.now
      if !@project.users.include?(current_user)
        @project.users << current_user
        @project.save
        redirect_to project_path(@project), notice: "Joined Project"
        Rails.logger.info "Invite: #{project_invite.inspect} 312"
      end
        redirect_to project_path(@project), alert: "Already Apart of this project"
        Rails.logger.info "ALREADY IN 312"
    else
        redirect_to root_path, alert: "Invite expired or invalid"
        Rails.logger.info "FAILED TO FIND 312"
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
