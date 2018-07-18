class DropColumnPictureFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :picture
  end
end
