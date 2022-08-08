# frozen_string_literal: true

class CompanyPolicy
  attr_reader :user

  def initialize(user, company)
    @user = user
    @company = company
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def update?
    @user.admin? || owner?
  end

  private

  def owner?
    @user.id == @company.user_id
  end
end
