require 'rails_helper'

RSpec.describe TaskType, type: :model do
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
    # month with no mapping should be 0 (monthly_counts explicitly controls months)
    expect(tt.times_for_cycle_that_month(12)).to eq(0)
  end

  it 'rejects invalid monthly_counts values' do
    tt = TaskType.new(name: 'Lawn', times_per_cycle: 1, monthly_counts: { '0' => 2, '13' => 1 })
    expect(tt).not_to be_valid
  end
end
