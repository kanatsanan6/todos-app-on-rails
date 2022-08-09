# frozen_string_literal: true

class CompanyPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if @user.admin?
        @scope.all
      else
        membership = Membership.where(user_id: @user.id)
        @scope.where(id: membership.pluck(:company_id))
      end
    end
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

  def owner?
    @user.id == @record[:company].user_id
  end
end
