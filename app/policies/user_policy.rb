# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def edit?
    update?
  end

  def destroy?
    update?
  end

  def update?
    admin? || owner?
  end

  private

  def admin?
    user.admin?
  end

  def owner?
    user.id == record[:user].id
  end
end
