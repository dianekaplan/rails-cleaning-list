class AddActiveToTaskTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :task_types, :active, :boolean, default: true, null: false
  end
end
