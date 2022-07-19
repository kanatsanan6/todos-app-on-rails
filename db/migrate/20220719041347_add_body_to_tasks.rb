class AddBodyToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :body, :text
  end
end
