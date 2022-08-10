# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :company
  before_action :task, only: %i[create update destroy edit]
  before_action :comment, only: %i[update destroy edit]
  before_action :check_owner, only: %i[edit update]
  before_action :check_member, only: %i[create]

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def create
    @comment = @task.comments.new(comment_params)

    if @comment.save
      redirect_to company_task_path(@company, @task)
    else
      redirect_to company_task_path(@company, @task), status: :see_other
    end
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

  def company
    @company ||= Company.find(params[:company_id])
  end

  def task
    @task ||= @company.tasks.find(params[:task_id])
  end

  def comment
    @comment ||= @task.comments.find(params[:id])
  end

  def check_owner
    authorize({ comment: @comment }, policy_class: CommentPolicy)
  end

  def check_member
    authorize({ company: @company }, policy_class: CommentPolicy)
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def user_not_authorized
    redirect_to company_task_path(@company, @task)
  end
end
