# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end
