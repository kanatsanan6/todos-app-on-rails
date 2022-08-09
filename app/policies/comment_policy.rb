# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def create?
    admin? || member?
  end

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

  def member?
    return true if record[:company].memberships.find_by(user_id: user.id).present?

    false
  end

  def owner?
    user.id == record[:comment].user_id
  end
end
