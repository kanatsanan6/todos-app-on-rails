# frozen_string_literal: true

class CommentPolicy
  attr_reader :user

  def initialize(user, target_comment)
    @user = user
    @target_comment = target_comment
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def update?
    (@user.has_role? :admin) || (@user.id == @target_comment.user_id)
  end
end
