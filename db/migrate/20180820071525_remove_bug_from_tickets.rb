class RemoveBugFromTickets < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :bug
  end
end
