class ActionsController < ApplicationController
  before_action :set_action, only: %i[ user_is_apart_of_project show]
  before_action :authenticate_user!
  before_action :user_is_apart_of_project, only: %i[show]
  # GET /actions or /actions.json
  def index
    @actions = Action.all
  end

  # GET /actions/1 or /actions/1.json
  def show
  end

  # GET /actions/new
  def new
    @action = Action.new
  end

  def user_is_apart_of_project
    # flash.now[:notice] = "Update successful"
    if !@action.project.users.include?(current_user)
      redirect_to projects_path, notice: "Not apart of project"
    end
  end
  # POST /actions or /actions.json
  def create
    @action = Action.new(action_params)

    respond_to do |format|
      if @action.save
        format.html { redirect_to @action, notice: "Action was successfully created." }
        format.json { render :show, status: :created, location: @action }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /actions/1 or /actions/1.json
  def update
    respond_to do |format|
      if @action.update(action_params)
        format.html { redirect_to @action, notice: "Action was successfully updated." }
        format.json { render :show, status: :ok, location: @action }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @action.errors, status: :unprocessable_entity }
      end
    end
  end
  # handling collpasability
  def section
    section_target = "action_section_"+params[:parent].to_s
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(section_target, partial: "actions/section", locals: action_section_params)
        ]
      end
    end
  end

  def section_reset
    section_target = "action_section_"+params[:parent].to_s
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(section_target, partial: "actions/section_unexpanded", locals: action_section_params)
        ]
      end
    end
  end
  private
  def action_section_params
    # Expects parent, commentable, isProject %>
    params.slice(:parent, :actionable, :includeList)
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_action
      @action = Action.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def action_params
      params.expect(action: [ :id, :project_id, :user_id, :user_fullname, :entry_id, :type, :description ])
    end
end
