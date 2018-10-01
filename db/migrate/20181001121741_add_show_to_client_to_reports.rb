class AddShowToClientToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :show_to_client, :boolean
  end
end
