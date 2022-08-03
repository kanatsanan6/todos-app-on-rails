# frozen_string_literal: true

class TaskMailer < ApplicationMailer
  default from: 'railstestingemail1@gmail.com'

  def reminder_email
    @email = params[:email]
    @tasks = JSON.parse(params[:tasks])

    mail(to: @email, subject: 'A reminder from todos-on-rails!')
  end
end
