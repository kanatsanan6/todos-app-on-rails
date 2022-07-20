class UpdatesStatusTypeFromBooleanToInteger < ActiveRecord::Migration[7.0]
  def up
    change_column_default :tasks, :status, nil
    change_column :tasks, :status, :integer, using: 'CAST(status AS integer)', default: 0
  end

  def down
    change_column_default :tasks, :status, nil
    change_column :tasks, :status, :boolean, using: 'CAST(status AS boolean)', default: false
  end
end
