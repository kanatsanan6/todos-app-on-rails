# frozen_string_literal: true

class TaskPolicy
  attr_reader :user

  def initialize(user, target_task)
    @user = user
    @target_task = target_task
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def update?
    (@user.has_role? :admin) || (@user.id == @target_task.user_id)
  end
end
