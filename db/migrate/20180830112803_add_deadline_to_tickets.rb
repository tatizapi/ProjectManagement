class AddDeadlineToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :deadline, :datetime
  end
end
