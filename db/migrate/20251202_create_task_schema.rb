class CreateTaskSchema < ActiveRecord::Migration[7.0]
  def change
    create_table :task_types do |t|
      t.string :name, null: false
      t.text :description
      t.integer :times_per_cycle, null: false, default: 1

      t.timestamps
    end

    create_table :cycles do |t|
      t.date :start_date, null: false
      t.date :end_date

      t.timestamps
    end

    create_table :task_instances do |t|
      t.references :task_type, null: false, foreign_key: { to_table: :task_types }
      t.references :cycle, null: false, foreign_key: { to_table: :cycles }
      t.boolean :completed_bool, null: false, default: false
      t.datetime :completed_date

      t.timestamps
    end
  end
end
