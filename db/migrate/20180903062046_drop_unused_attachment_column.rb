class DropUnusedAttachmentColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :attachments
    remove_column :projects, :attachments
    remove_column :tickets, :attachments
  end
end
