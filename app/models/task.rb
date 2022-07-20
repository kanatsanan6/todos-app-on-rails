# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end
