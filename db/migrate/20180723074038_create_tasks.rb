class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :attachments
      t.string :status
      t.string :priority
      t.datetime :created_at
      t.datetime :completed_at
      t.datetime :started_at
      t.datetime :ended_at
      t.references :employee
    end
  end
end
