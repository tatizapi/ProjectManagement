class AddAttachmentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :attachment, :string
  end
end
