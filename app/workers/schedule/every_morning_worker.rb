# frozen_string_literal: true

module Schedule
  class EveryMorningWorker
    include Sidekiq::Worker

    sidekiq_options queue: :schedule, retry: 0

    def perform
      User.find_each do |user|
        @tasks = (Task.where(scope: :scope_public) || Task.where(user_id: user.id)).where.not(status: :done)

        TaskMailer.with(email: user.email, tasks: @tasks.as_json).reminder_email.deliver_later
      end
    end
  end
end
