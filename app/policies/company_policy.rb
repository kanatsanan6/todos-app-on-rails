# frozen_string_literal: true

class CompanyPolicy < ApplicationPolicy
  def edit?
    update?
  end

  def destroy?
    update?
  end

  def update?
    user.admin? || owner?
  end

  private

  def owner?
    @user.id == @record[:company].user_id
  end
end
