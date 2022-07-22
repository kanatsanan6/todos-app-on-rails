# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_task, only: %i[create update destroy edit]
  before_action :set_comment, only: %i[update destroy edit]
  skip_before_action :verify_authenticity_token

  def create
    @comment = @task.comments.create!(comment_params)
    redirect_to task_path(@task)
  rescue ActiveRecord::RecordInvalid
    redirect_to task_path(@task)
  end

  def edit
    return redirect_to task_path(@task) unless @comment.user_id == current_user.id
  end

  def update
    return redirect_to task_path(@task) unless @comment.user_id == current_user.id

    if @comment.update(comment_params)
      redirect_to task_path(@task)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy if @comment.user_id == current_user.id

    redirect_to task_path(@task), status: :see_other
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
