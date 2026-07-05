require 'rails_helper'

RSpec.describe TaskType, type: :model do
  describe 'active field' do
      it 'defaults to true' do
        tt = TaskType.new(name: 'ActiveDefault', times_per_cycle: 1)
        expect(tt.active).to eq(true)
      end

      it 'can be set to false' do
        tt = TaskType.new(name: 'Inactive', times_per_cycle: 1, active: false)
        expect(tt.active).to eq(false)
      end

      it 'can be saved and loaded as false' do
        tt = TaskType.create!(name: 'Inactive', times_per_cycle: 1, active: false)
        expect(TaskType.find(tt.id).active).to eq(false)
      end

      it 'can be saved and loaded as true' do
        tt = TaskType.create!(name: 'Active', times_per_cycle: 1, active: true)
        expect(TaskType.find(tt.id).active).to eq(true)
      end
    end
  it 'is valid with name and times_per_cycle' do
    tt = TaskType.new(name: 'Clean', times_per_cycle: 2)
    expect(tt).to be_valid
  end

  it 'is valid without a description' do
    tt = TaskType.new(name: 'NoDesc', times_per_cycle: 1, description: nil)
    expect(tt).to be_valid
  end

  it 'defaults times_per_cycle to 1 when not provided' do
    tt = TaskType.new(name: 'DefaultTask')
    expect(tt.times_per_cycle).to eq(1)
    expect(tt).to be_valid
  end

  it 'requires times_per_cycle to be a positive integer' do
    tt = TaskType.new(name: 'A', times_per_cycle: 0)
    expect(tt).not_to be_valid
  end


  it 'accepts monthly_counts mapping and returns times_for_cycle_that_month properly' do
    tt = TaskType.new(name: 'Lawn', times_per_cycle: 1, monthly_counts: { '5' => 2, '6' => 2, '9' => 1 })
    expect(tt).to be_valid
    expect(tt.times_for_cycle_that_month(5)).to eq(2)
    expect(tt.times_for_cycle_that_month(9)).to eq(1)
    # months with no mapping should be 0 when monthly_counts explicitly controls the months
    expect(tt.times_for_cycle_that_month(12)).to eq(0)
  end

  it 'falls back to times_per_cycle when monthly_counts has a blank value for a month' do
    tt = TaskType.new(name: 'Lawn', times_per_cycle: 3, monthly_counts: { '5' => '', '6' => 2 })

    expect(tt.times_for_cycle_that_month(5)).to eq(3)
    expect(tt.times_for_cycle_that_month(6)).to eq(2)
  end

  it 'rejects invalid monthly_counts values' do
    tt = TaskType.new(name: 'Lawn', times_per_cycle: 1, monthly_counts: { '0' => 2, '13' => 1 })
    expect(tt).not_to be_valid
  end
end
