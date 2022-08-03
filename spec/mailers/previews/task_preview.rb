# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/task
class TaskPreview < ActionMailer::Preview
  def reminder
    @tasks = (Task.where(scope: :scope_public) || Task.where(user_id: 1)).where.not(status: :done)

    TaskMailer.with(email: 'test@example.com', tasks: @tasks).reminder_email
  end
end
