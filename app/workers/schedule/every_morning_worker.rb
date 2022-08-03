# frozen_string_literal: true

module Schedule
  class EveryMorningWorker
    include Sidekiq::Worker

    sidekiq_options queue: :schedule, retry: 0

    def perform
      User.find_each do |user|
        @tasks = Task.all.where(scope: :scope_public).or(Task.where(user_id: user.id))

        TaskMailer.with(email: user.email, tasks: @tasks.to_json).reminder_email.deliver_later
      end
    end
  end
end
