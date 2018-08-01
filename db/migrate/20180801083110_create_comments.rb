class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.string :attachments
      t.references :user
      t.references :task
    end
  end
end
