# frozen_string_literal: true

class MembershipsController < ApplicationController
  before_action :set_company, only: %i[index new create destroy]
  before_action :set_membership, only: %i[destroy]

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
  end

  def destroy
    redirect_to company_memberships_path, status: :see_other if @membership.destroy
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_membership
    @membership = @company.memberships.find(params[:id])
  end

  def membership_params
    @email = params[:membership][:email]
    params.permit(:membership).merge({ user: User.find_by(email: @email) })
  end

  def order(membership)
    membership.order(:created_at)
  end
end
