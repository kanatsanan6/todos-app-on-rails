# frozen_string_literal: true

module Schedule
  class EveryMorningWorker
    include Sidekiq::Worker

    sidekiq_options queue: :schedule, retry: 0

    def perform
      User.find_each do |user|
        TaskMailer.with(email: user.email).reminder_email.deliver_later
      end
    end
  end
end
