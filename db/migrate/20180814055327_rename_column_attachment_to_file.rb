class RenameColumnAttachmentToFile < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :attachment, :file
  end
end
