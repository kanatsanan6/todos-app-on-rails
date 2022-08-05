# frozen_string_literal: true

class DropCompaniesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :companies
  end
end
