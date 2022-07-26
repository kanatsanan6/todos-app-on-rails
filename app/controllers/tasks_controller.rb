# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :check_user, only: %i[edit update]

  def index
    if params[:search]
      @tasks_by_status = status_params.nil? ? Task.all : Task.search_by_status(status_params)
      @tasks_by_status_and_user = user_id_params.nil? ? @tasks_by_status : @tasks_by_status.search_by_user_id(user_id_params)
      @tasks = @tasks_by_status_and_user.order(:created_at).page(params[:page])
    else
      @tasks = Task.order(:created_at).page(params[:page])
    end
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

  def set_task
    @task = Task.find(params[:id])
  end

  def check_user
    return redirect_to root_url unless @task.user_id == current_user.id
  end

  def task_params
    params.require(:task).permit(:title, :body, :status)
  end

  def status_params
    params.require(:search).permit(:status)[:status]
  end

  def user_id_params
    params.require(:search).permit(:user_id)[:user_id]
  end
end
