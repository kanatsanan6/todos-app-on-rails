# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[edit update destroy]

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
    @company.destroy
    redirect_to companies_path, status: :see_other
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name).merge(user: current_user)
  end
end
