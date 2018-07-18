class AddAttachmentsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :attachments, :string
  end
end
