class RemoveActiveMonthsFromTaskTypes < ActiveRecord::Migration[7.2]
  def change
    remove_column :task_types, :active_months, :text
  end
end
