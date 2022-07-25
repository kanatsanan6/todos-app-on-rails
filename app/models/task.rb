# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true

  enum :status, { pending: 0, in_progress: 1, done: 2 }

  paginates_per 6
end
