# frozen_string_literal: true

require 'rails_helper'
require 'fugit'

RSpec.describe Schedule::EveryMorningWorker, type: :worker do
  let(:time) { (Time.zone.tomorrow + 8.hours) }
  let(:scheduled_job) { described_class.perform_at(time) }
  let!(:user) { create(:user) }

  describe 'testing worker' do
    it 'is enqueued in the schedul queue' do
      expect(described_class).to be_processed_in :schedule
    end

    it 'is retryable' do
      expect(described_class).to be_retryable 0
    end

    it 'matches with enqueued mailer' do
      ActiveJob::Base.queue_adapter = :test
      expect { described_class.new.perform }.to have_enqueued_mail(TaskMailer, :reminder_email)
    end

    it 'goes into jobs array for testing environment' do
      expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1)
    end
  end

  describe 'testing scheduled tasks' do
    schedule_file = Rails.root.join('config/schedule.yml')
    schedule = YAML.load_file(schedule_file)

    context 'check cron syntax' do
      schedule.each do |cron_name, cron_info|
        cron = cron_info['cron']

        it "#{cron_name} has correct cron syntax" do
          expect { Fugit.do_parse(cron) }.not_to raise_error
        end
      end
    end

    context 'check scheduled tasks' do
      it 'has a correct setting and occured at given time' do
        scheduled_job
        job = described_class.jobs.last

        expect(job['jid'].include?(scheduled_job)).to eq true
        expect(job['queue']).to eq 'schedule'
        expect(job['class']).to eq described_class.to_s
        expect(job['retry']).to eq 0
        expect(Time.zone.at(job['at'])).to eq time
      end
    end
  end
end
