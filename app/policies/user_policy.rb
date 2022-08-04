# frozen_string_literal: true

class UserPolicy
  class Scope
    def resolve
      scope.all
    end
  end

  def initialize(user, target_user)
    @user = user
    @target_user = target_user
  end

  def edit?
    update?
  end

  def update?
    (@user.has_role? :admin) || (@user.id == @target_user.id)
  end
end
