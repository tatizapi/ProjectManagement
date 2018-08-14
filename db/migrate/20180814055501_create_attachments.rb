class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :filename
      t.string :file_type
      t.string :file
      t.references :container, polymorphic: true
    end
  end
end
