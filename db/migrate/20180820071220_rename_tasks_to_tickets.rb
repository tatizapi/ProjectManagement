class RenameTasksToTickets < ActiveRecord::Migration[5.2]
  def change
    rename_table :tasks, :tickets
  end
end
