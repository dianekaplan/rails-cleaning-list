# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_12_02_185000) do
  create_table "cycles", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_instances", force: :cascade do |t|
    t.integer "task_type_id", null: false
    t.integer "cycle_id", null: false
    t.boolean "completed_bool", default: false, null: false
    t.datetime "completed_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cycle_id"], name: "index_task_instances_on_cycle_id"
    t.index ["task_type_id"], name: "index_task_instances_on_task_type_id"
  end

  create_table "task_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "times_per_cycle", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "monthly_counts"
  end

  add_foreign_key "task_instances", "cycles"
  add_foreign_key "task_instances", "task_types"
end
