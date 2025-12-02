class AddMonthlyCountsToTaskTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :task_types, :monthly_counts, :text
  end
end
