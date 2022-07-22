# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'Test 1' }
    body { 'Test Body 1234' }
    status { :in_progress }
  end
end
