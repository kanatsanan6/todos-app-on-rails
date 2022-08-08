# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test-#{n}@sample.com" }
    password { '123456' }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/example.png')) }

    factory :admin do
      after(:create) { |user| user.role = 1 }
    end
  end
end
