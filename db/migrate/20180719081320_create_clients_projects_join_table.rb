class CreateClientsProjectsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :clients, :projects do |t|
      t.index :client_id
      t.index :project_id
    end
  end
end
