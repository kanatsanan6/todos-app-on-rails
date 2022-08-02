# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :check_user, only: %i[edit update]
  before_action :check_scope, only: %i[show]

  def index
    @tasks =
      Task.all
          .then(&method(:filter_by_status))
          .then(&method(:filter_by_user_id))
          .then(&method(:filter_by_title_body))
          .then(&method(:filter_by_scope))
          .then(&method(:order))
          .then(&method(:paginate))
  end

  def show
    @task_comments = @task.comments.order(:created_at).page(params[:page])
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy if @task.user_id == current_user.id

    redirect_to root_url, status: :see_other
  end

  private

  def filter_by_scope(tasks)
    if params&.dig(:search, :scope).present?
      return tasks.where(scope: scope_params) if scope_params == :scope_public.to_s

      tasks.where(scope: scope_params, user_id: current_user.id)
    else
      tasks.where(scope: :scope_public).or(tasks.where(user_id: current_user.id))
    end
  end

  def filter_by_title_body(tasks)
    if params&.dig(:search, :title).present?
      tasks.search_by_title_body(title_params)
    else
      tasks
    end
  end

  def filter_by_status(tasks)
    if params&.dig(:search, :status).present?
      tasks.where(status: status_params)
    else
      tasks
    end
  end

  def filter_by_user_id(tasks)
    if params&.dig(:search, :user_id).present?
      tasks.search_by_user_id(user_id_params)
    else
      tasks
    end
  end

  def order(tasks)
    tasks.order(:created_at)
  end

  def paginate(tasks)
    tasks.page(params[:page])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def check_user
    return redirect_to root_url unless @task.user_id == current_user.id
  end

  def check_scope
    return redirect_to root_url if @task.scope_private? && @task.user_id != current_user.id
  end

  def task_params
    params.require(:task).permit(:title, :body, :status, :scope)
  end

  def title_params
    params.require(:search).permit(:title)[:title]
  end

  def status_params
    params.require(:search).permit(:status)[:status]
  end

  def user_id_params
    params.require(:search).permit(:user_id)[:user_id]
  end

  def scope_params
    params.require(:search).permit(:scope)[:scope]
  end
end
