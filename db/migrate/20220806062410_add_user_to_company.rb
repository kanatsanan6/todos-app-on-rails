# frozen_string_literal: true

class AddUserToCompany < ActiveRecord::Migration[7.0]
  def change
    add_reference :companies, :user, null: false, foreign_key: true
  end
end
