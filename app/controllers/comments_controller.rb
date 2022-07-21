# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_task, only: %i[create update destroy edit]
  before_action :set_comment, only: %i[update destroy edit]
  skip_before_action :verify_authenticity_token

  def create
    @comment = @task.comments.create!(comment_params)
    redirect_to task_path(@task)
  rescue StandardError
    render :new, status: :unprocessable_entity
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to task_path(@task)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy

    redirect_to task_path(@task)
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
