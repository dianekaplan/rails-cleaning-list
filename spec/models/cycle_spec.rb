require 'rails_helper'

RSpec.describe Cycle, type: :model do
  it 'is valid with a start_date' do
    c = Cycle.new(start_date: Date.today)
    expect(c).to be_valid
  end

  it 'validates end_date is after start_date' do
    c = Cycle.new(start_date: Date.today, end_date: Date.today - 1)
    expect(c).not_to be_valid
  end

  it 'creates TaskInstance records for each TaskType after create' do
    # t1 no monthly_counts (always active) -> 1
    t1 = TaskType.create!(name: 'A', times_per_cycle: 1)
    # t2 active only month 2 using monthly_counts -> not created for month 1
    binding.break
    t2 = TaskType.create!(name: 'B', times_per_cycle: 2, monthly_counts: { '2' => 2 })
    # t3 active only month 1 using monthly_counts -> created
    t3 = TaskType.create!(name: 'C', times_per_cycle: 1, monthly_counts: { '1' => 1 })

    initial = TaskInstance.count
    Cycle.create!(start_date: Date.new(2025, 1, 1))
    # expected created: t1 (1) + t3 (1) = 2
    expect(TaskInstance.count).to eq(initial + 2)
  end

  it 'respects monthly_counts when creating TaskInstances' do
    mowing = TaskType.create!(name: 'Mowing', times_per_cycle: 1, monthly_counts: { '5' => 2, '6' => 2, '7' => 2, '8' => 2, '9' => 1, '10' => 1 })

    initial = TaskInstance.count
    Cycle.create!(start_date: Date.new(2025, 5, 1))
    expect(TaskInstance.count).to eq(initial + 2) # mowing -> 2 in month 5
  end

  it 'creates zero TaskInstances for months not in monthly_counts' do
    mowing = TaskType.create!(name: 'Mowing', times_per_cycle: 1, monthly_counts: { '5' => 2, '6' => 2, '7' => 2, '8' => 2, '9' => 1, '10' => 1 })

    initial = TaskInstance.count
    Cycle.create!(start_date: Date.new(2025, 12, 1))
    expect(TaskInstance.count).to eq(initial + 0) # mowing -> 0 in month 12 (not in monthly_counts)
  end

  describe '.current_cycle' do
    it 'returns the cycle with the latest end_date' do
      cycle1 = Cycle.create!(start_date: Date.new(2025, 1, 1), end_date: Date.new(2025, 1, 31))
      cycle2 = Cycle.create!(start_date: Date.new(2025, 2, 1), end_date: Date.new(2025, 2, 28))
      cycle3 = Cycle.create!(start_date: Date.new(2025, 3, 1), end_date: Date.new(2025, 3, 31))

      expect(Cycle.current_cycle).to eq(cycle3)
    end

    it 'returns nil when there are no cycles' do
      Cycle.destroy_all
      expect(Cycle.current_cycle).to be_nil
    end
  end

  describe 'destroying a cycle' do
    it 'destroys associated task_instances when cycle is destroyed' do
      task_type = TaskType.create!(name: 'Test Task', times_per_cycle: 2)
      cycle = Cycle.create!(start_date: Date.new(2025, 1, 1), end_date: Date.new(2025, 1, 31))

      expect(cycle.task_instances.count).to eq(2)
      task_instance_ids = cycle.task_instances.pluck(:id)

      cycle.destroy

      expect(TaskInstance.where(id: task_instance_ids)).to be_empty
    end

    it 'updates current_cycle after destroying the current cycle' do
      cycle1 = Cycle.create!(start_date: Date.new(2025, 1, 1), end_date: Date.new(2025, 1, 31))
      cycle2 = Cycle.create!(start_date: Date.new(2025, 2, 1), end_date: Date.new(2025, 2, 28))

      expect(Cycle.current_cycle).to eq(cycle2)

      cycle2.destroy

      expect(Cycle.current_cycle).to eq(cycle1)
    end
  end
end
