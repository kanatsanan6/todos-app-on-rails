class RemoveCommenterFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :commenter
  end
end
