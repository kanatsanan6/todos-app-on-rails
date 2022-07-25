# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :body, presence: true
  paginates_per 4
end
