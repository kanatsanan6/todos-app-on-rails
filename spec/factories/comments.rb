# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    commenter { 'Commenter 1' }
    body { 'Test comment 1234' }
    task { build(:task) }
  end
end
