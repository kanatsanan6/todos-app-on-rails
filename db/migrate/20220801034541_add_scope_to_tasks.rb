class AddScopeToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :scope, :integer, null: false, default: 0
  end
end
