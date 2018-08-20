class RenameTaskIdToTicketIdComments < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :task_id, :ticket_id
  end
end
