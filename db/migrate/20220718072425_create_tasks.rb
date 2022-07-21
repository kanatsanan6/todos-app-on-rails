# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, default: ''
      t.boolean :status, null: false, default: false

      t.timestamps
    end
  end
end
