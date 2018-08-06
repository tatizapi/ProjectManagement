class AddBugToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :bug, :boolean
  end
end
