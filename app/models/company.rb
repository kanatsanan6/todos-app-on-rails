# frozen_string_literal: true

class Company < ApplicationRecord
  belongs_to :user
  has_many :membership
  has_many :users, through: :membership

  validates :name, presence: true
end
