# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Demo TaskTypes to help get started locally
require "yaml"

task_types_file = Rails.root.join("db", "seeds", "task_types.yml")
if File.exist?(task_types_file)
  task_types = YAML.load_file(task_types_file, aliases: true)
  task_types.each do |attrs|
    tt = TaskType.find_or_initialize_by(name: attrs["name"])
    tt.description = attrs["description"] if attrs["description"]
    tt.times_per_cycle = attrs["times_per_cycle"] || tt.times_per_cycle || 1
    tt.monthly_counts = attrs["monthly_counts"] if attrs["monthly_counts"]
    tt.save!
  end
else
  puts "No db/seeds/task_types.yml found — skipping task type seeds"
end
