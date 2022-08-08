# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_company
  before_action :set_task, only: %i[create update destroy edit]
  before_action :set_comment, only: %i[update destroy edit]
  before_action :check_user, only: %i[edit update]

  def create
    @comment = @task.comments.create!(comment_params)
    redirect_to company_task_path(@company, @task)
  rescue ActiveRecord::RecordInvalid
    redirect_to company_task_path(@company, @task)
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to company_task_path(@company, @task)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy if @comment.user_id == current_user.id

    redirect_to company_task_path(@company, @task), status: :see_other
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_task
    @task = @company.tasks.find(params[:task_id])
  end

  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  def check_user
    redirect_to company_task_path(@company, @task) and return unless @comment.user_id == current_user.id
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
