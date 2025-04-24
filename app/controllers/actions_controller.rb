class ActionsController < ApplicationController
  before_action :set_action, only: %i[ user_is_apart_of_project show edit update destroy ]
  before_action :authenticate_user!
  before_action :user_is_apart_of_project
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_action
      @action = Action.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def action_params
      params.expect(action: [ :id, :project_id, :user_id, :user_fullname, :entry_id, :type, :description ])
    end
end
