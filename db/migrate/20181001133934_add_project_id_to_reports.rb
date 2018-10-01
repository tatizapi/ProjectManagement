class AddProjectIdToReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :reports, :project
  end
end
