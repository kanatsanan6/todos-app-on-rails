# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :commenter, null: false, default: ''
      t.text :body, null: false, default: ''
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
