class AddParentTaskToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :parent_task, :integer
  end
end
