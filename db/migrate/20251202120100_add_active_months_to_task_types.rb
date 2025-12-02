class AddActiveMonthsToTaskTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :task_types, :active_months, :text
  end
end
