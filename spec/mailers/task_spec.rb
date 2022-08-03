# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe 'checks task mailer' do
    let!(:task) { create(:task) }
    let!(:mail) { TaskMailer.with(email: 'test@email.com', tasks: Task.all.as_json).reminder_email }

    it 'renders the correct subject' do
      expect(mail.subject).to eq('A reminder from todos-on-rails!')
    end

    it 'renders the correct receiver' do
      expect(mail.to).to match_array ['test@email.com']
    end

    it 'renders the correct sender' do
      expect(mail.from).to match_array ['railstestingemail1@gmail.com']
    end
  end
end
