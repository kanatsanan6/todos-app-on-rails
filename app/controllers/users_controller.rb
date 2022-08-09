# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user, only: %i[show edit update]
  before_action :check_authorization, only: %i[edit update]

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      redirect_to root_url
    end
  end

  private

  def check_authorization
    redirect_to @user and return unless current_user.id == @user.id
  end

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:avatar, :username)
  end
end
