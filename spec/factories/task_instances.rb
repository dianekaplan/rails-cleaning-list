FactoryBot.define do
  factory :task_instance do
    association :task_type
    association :cycle
    completed_bool { false }
  end
end
