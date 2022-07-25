# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :check_user, only: %i[edit update]

  def index
    @tasks = Task.order(:created_at).page(params[:page])
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
end
