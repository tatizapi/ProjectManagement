class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.integer :employee_id, :null => false
      t.integer :project_id, :null => false
      t.string :role
    end
  end
end
