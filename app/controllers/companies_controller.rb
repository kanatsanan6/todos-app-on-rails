# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[edit update destroy]
  before_action :check_authorize, only: %i[edit update destroy]

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to companies_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @company.update(company_params)
      redirect_to companies_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to companies_path, status: :see_other if @company.destroy
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name).merge(user: current_user)
  end

  def check_authorize
    authorize({ company: @company }, policy_class: CompanyPolicy)
  end

  def user_not_authorized
    redirect_to companies_path
  end
end
