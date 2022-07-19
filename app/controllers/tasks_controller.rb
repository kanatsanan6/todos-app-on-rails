# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all.sort_by(&:id)
  end

  def show
    @task = Task.find(params[:id])
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
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to root_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to root_url, status: :see_other
  end

  private

  def task_params
    # convert status attrbute from check_box input to boolean
    params[:task][:status] = ActiveRecord::Type::Boolean.new.deserialize(params[:task][:status])
    params.require(:task).permit(:title, :body, :status)
  end
end
