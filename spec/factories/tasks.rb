# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'Test 1' }
    body { 'Test Body 1234' }
    status { false }
  end

  factory :task2 do
    title { 'Test 2' }
    body { 'Test Body 1234' }
    status { true }
  end
end
