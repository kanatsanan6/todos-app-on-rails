# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update]

  def index
    @tasks = Task.all.sort_by(&:id)
  end

  def show
    set_task
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set_task
  end

  def update
    set_task

    if @task.update(task_params)
      redirect_to root_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    set_task
    @task.destroy

    redirect_to root_url, status: :see_other
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    # convert status attrbute from check_box input to boolean
    params[:task][:status] = ActiveRecord::Type::Boolean.new.deserialize(params[:task][:status])
    params.require(:task).permit(:title, :body, :status)
  end
end
