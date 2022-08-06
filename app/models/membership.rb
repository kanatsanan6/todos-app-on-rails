# frozen_string_literal: true

class Membership < ApplicationRecord
  belongs_to :company
  belongs_to :user
end
