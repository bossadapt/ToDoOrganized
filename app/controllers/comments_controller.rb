class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show ]
  before_action :authenticate_user!
  before_action :user_is_apart_of_project, only: [ :show, :index ]
  # GET /comments or /comments.json
  def index
    @comments = Comment.where(author: current_user)
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new(
      project_id: params[:project_id],
      commentable_id: params[:commentable_id],
      commentable_type: params[:commentable_type]
    )

    respond_to do |format|
      format.turbo_stream { render :new } # Ensure this renders the correct view
      format.html # For full-page requests
    end
  end

  def user_is_owner
    @comment = Comment.find_by(id: params[:id], author: current_user)
    redirect_to projects_path, notice: "Only Owners of the comment is able to do this" if @comment.nil?
  end
  def user_is_apart_of_project
    @comment = Comment.find_by(id: params[:id])
    redirect_to projects_path, notice: "Not apart of project" if @comment.nil? || !@comment.project.users.include?(current_user)
  end
  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_create_params)
    @comment.author = current_user
    @comment.author_fullname = current_user.first_name + " " + current_user.last_name
    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to comments_path, notice: "Quote was successfully created."  }
      else
        format.turbo_stream
        logger.debug "Array of errors"
        logger.debug @comment.errors.to_a
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_create_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def comment_create_params
      params.expect(comment: [ :title, :body, :project_id, :commentable_id, :commentable_type ])
    end
    def comment_show_params
      params.expect(comment: [ :title, :body ])
    end
end
