class AddColumnCreatedByToReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :reports, :user
  end
end
