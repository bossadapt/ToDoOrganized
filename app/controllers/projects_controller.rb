class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy generate_invite use_invite leave_project]
  before_action :authenticate_user!
  before_action :user_is_owner, only: [ :edit, :update, :destroy, :generate_invite, :project_kick ]
  before_action :user_is_apart_of_project, only: [ :show, :show_all_actions, :show_all_comments, :leave_project ]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  include ActionView::RecordIdentifier

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
    respond_to do |format|
      format.turbo_stream # For Turbo Frame requests
      format.html # For full-page requests
    end
  end
  def user_is_owner
    @project = Project.find_by(id: params[:id], owner_id: current_user.id)
    if @project.nil?
      flash.now[:notice] = "Only the owner can edit, delete or generate invites for the project"
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
    end
  end
  def user_is_apart_of_project
    @project = Project.find(params[:id])
    redirect_to projects_path, notice: "Not apart of project or no longer exists" if !@project.users.include?(current_user)
  end
  def show_all_actions
    @project = Project.find(params[:id])
    @actions = @project.actions.ordered
    respond_to do |format|
      format.turbo_stream
      # format.html { render partial: "actions/actions", locals: { actions: @actions, parent: "", includeList: [ "Entry", "Action Type", "Author", "Description", "Time" ] } }
    end
  end
  def show_all_comments
    @project = Project.find(params[:id])
    @comments = @project.comments.ordered
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
          targeting_project_entry: false,
          author_fullname: current_user.full_name,
          action_type: "Create",
          description: @project.to_description
        )
        format.html { redirect_to @project, notice: "Project was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    description = ""
    if @project.title != project_params[:title]
      description += "Title changed from '#{@project.title}' to '#{project_params[:title]}'\n"
    end
    if @project.description != project_params[:description]
      description += "Desciption changed from '#{@project.description}' to '#{project_params[:description]}'\n"
    end
    if description == ""
      render turbo_stream: turbo_stream.replace(dom_id(@project, :edit), partial: "projects/project_editable", locals: { project: @project })
      respond_to do |format|
        format.json { render :show, status: :ok, location: @project }
        return
      end
    else
      respond_to do |format|
        if @project.update(project_params)
          @project.actions.create(
            author_id: current_user.id,
            targeting_project_entry: false,
            author_fullname: current_user.full_name,
            action_type: "Edit",
            description: description
          )
          # unsure why this is needed even though there is a turbo frame setup but it is...
          format.turbo_stream do
            # make to project title section should have a seprate stream so that the project dashborad also stays up to date
            Turbo::StreamsChannel.broadcast_replace_to @project.id.to_s+"_header", target: dom_id(@project, :edit), partial: "projects/project_editable", locals: { project: @project }
          end
          format.html { redirect_to @project, notice: "Project was successfully updated." }
          format.json { render :show, status: :ok, location: @project }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.project_entries.destroy_all
    @project.comments.destroy_all
    @project.actions.destroy_all
    @project.project_invites.destroy_all
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, status: :see_other, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  # GET /projects/1/generate-invite/
  def generate_invite
    code_generated = SecureRandom.uuid
    invite = @project.project_invites.create(
      link_code: code_generated,
      expiration: DateTime.now + 1
    )
    if invite.persisted?
      link_generated =  "#{request.base_url}/todoorganized/projects/#{@project.id}/use-invite/#{code_generated}"
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
        Turbo::StreamsChannel.broadcast_append_to @project.id.to_s+"_header", target: @project.id.to_s + "_users_dropdown_contents", partial: "projects/user_entry_general", locals: { project: @project, user: current_user }
        redirect_to project_path(@project), notice: "Joined Project"
      else
        redirect_to project_path(@project), alert: "Already apart of project"
      end
    else
        redirect_to root_path, alert: "Invite expired or invalid"
    end
  end
  def leave_project
    @project.users.delete(current_user)
    @project.save
    respond_to do |format|
      format.html do
        Rails.logger.debug "||||| RAN THE HTML"
        Turbo::StreamsChannel.broadcast_remove_to @project.id.to_s+"_header", target: @project.id.to_s+"_users_dropdown_contents_"+current_user.id.to_s
        redirect_to projects_path, notice: "Left project"
      end
    end
  end
  def project_kick
    @project.users.delete(params[:user_id])
    @project.save
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "User was kicked from project"
        Turbo::StreamsChannel.broadcast_remove_to @project.id.to_s+"_header", target: @project.id.to_s+"_users_dropdown_contents_"+params[:user_id]
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
      end
      format.html do
        redirect_to projects_path, notice: "Kicked from project"
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end
    def handle_record_not_found
      redirect_to projects_path, notice: "Project not found"
    end
    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :title, :description ])
    end
end
