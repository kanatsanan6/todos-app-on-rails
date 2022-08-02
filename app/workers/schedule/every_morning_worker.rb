# frozen_string_literal: true

class Schedule::EveryMorningWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mailer, retry: 0

  def perform
    User.find_each do |user|
      TaskMailer.with(email: user.email).reminder_email.deliver_later
    end
  end
end
