require 'rails_helper'

RSpec.describe TaskInstance, type: :model do
  before(:each) do
    @tt = TaskType.create!(name: 'Test', times_per_cycle: 1)
    @cycle = Cycle.create!(start_date: Date.today)
  end

  it 'is valid when associated and not completed' do
    ti = TaskInstance.new(task_type: @tt, cycle: @cycle, completed_bool: false)
    expect(ti).to be_valid
  end

  it 'requires completed_date when completed_bool is true' do
    ti = TaskInstance.new(task_type: @tt, cycle: @cycle, completed_bool: true, completed_date: nil)
    expect(ti).not_to be_valid
  end

  it 'mark_done! sets completed flags and date' do
    ti = TaskInstance.create!(task_type: @tt, cycle: @cycle, completed_bool: false)
    expect(ti.completed_bool).to be_falsey
    ti.mark_done!
    ti.reload
    expect(ti.completed_bool).to be_truthy
    expect(ti.completed_date.to_date.strftime('%m/%d/%Y')).to eq(Date.today.strftime('%m/%d/%Y'))
  end
end
