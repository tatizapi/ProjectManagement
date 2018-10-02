class AddSaveAsTemplateToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :save_as_template, :boolean
  end
end
