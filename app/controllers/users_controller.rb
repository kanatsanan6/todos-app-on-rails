# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
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
    return redirect_to @user unless current_user.id == @user.id
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
