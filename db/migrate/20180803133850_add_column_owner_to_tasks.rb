class AddColumnOwnerToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :owner, :integer
  end
end
