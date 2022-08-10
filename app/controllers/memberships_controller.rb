# frozen_string_literal: true

class MembershipsController < ApplicationController
  before_action :company, only: %i[index new create destroy]
  before_action :membership, only: %i[destroy]
  before_action :check_user, only: %i[new create destroy]

  def index
    @memberships = @company.memberships
                           .then(&method(:order))
  end

  def new
    @membership = @company.memberships.new
  end

  def create
    @membership = @company.memberships.create!(membership_params)
    redirect_to company_memberships_path
  rescue ActiveRecord::StatementInvalid
    render :new, status: :unprocessable_entity
    @membership = @company.memberships.new(membership_params)

    if @membership.save
      redirect_to company_memberships_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to company_memberships_path, status: :see_other if @membership.destroy
  end

  private

  def company
    @company ||= Company.find(params[:company_id])
  end

  def membership
    @membership ||= @company.memberships.find(params[:id])
  end

  def membership_params
    @email = params[:membership][:email]
    params.permit(:membership).merge({ user: User.find_by(email: @email) })
  end

  def order(membership)
    membership.order(:created_at)
    membership.order(created_at: :asc)
  end

  def check_user
    redirect_to company_memberships_path(@company) and return unless @company.user_id == current_user.id
  end
end
