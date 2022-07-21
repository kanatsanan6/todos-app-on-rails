# frozen_string_literal: true

class AddBodyToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :body, :text, null: false, default: ''
  end
end
