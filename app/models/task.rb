# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true

  enum :status, { pending: 0, in_progress: 1, done: 2 }
  enum :scope, { scope_public: 0, scope_private: 1 }

  paginates_per 6

  include PgSearch::Model
  pg_search_scope :search_by_user_id, against: :user_id
  pg_search_scope :search_by_title_body,
                  against: %i[title body],
                  using: {
                    tsearch: { prefix: true }
                  }
end
