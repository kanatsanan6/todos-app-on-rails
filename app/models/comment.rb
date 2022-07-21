# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task

  validates :commenter, presence: true
  validates :body, presence: true
end
