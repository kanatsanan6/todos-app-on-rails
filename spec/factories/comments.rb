# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'Test comment 1234' }
    user
    task
  end
end
