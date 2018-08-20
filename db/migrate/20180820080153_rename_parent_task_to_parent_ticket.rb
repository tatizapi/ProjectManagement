class RenameParentTaskToParentTicket < ActiveRecord::Migration[5.2]
  def change
    rename_column :tickets, :parent_task, :parent_ticket
  end
end
