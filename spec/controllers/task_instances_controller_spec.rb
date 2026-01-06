require 'rails_helper'

RSpec.describe TaskInstancesController, type: :controller do
  describe 'GET #index' do
    let!(:current_cycle) { create(:cycle) }
    let!(:past_cycle) { create(:cycle, start_date: 1.month.ago.beginning_of_month, end_date: 1.month.ago.end_of_month) }

    before do
      allow(Cycle).to receive(:current_cycle).and_return(current_cycle)
    end

    context 'sorting task types' do
      let!(:task_type_least_recent_incomplete) { create(:task_type) }
      let!(:task_type_most_recent_incomplete) { create(:task_type) }
      let!(:task_type_least_recent_completed) { create(:task_type) }
      let!(:task_type_most_recent_completed) { create(:task_type) }

      before do
        # Create past completions to set previous_completion_date
        create(:task_instance, task_type: task_type_least_recent_incomplete, cycle: past_cycle, completed_bool: true, completed_date: 2.months.ago)
        create(:task_instance, task_type: task_type_most_recent_incomplete, cycle: past_cycle, completed_bool: true, completed_date: 1.month.ago)
        create(:task_instance, task_type: task_type_least_recent_completed, cycle: past_cycle, completed_bool: true, completed_date: 2.months.ago)
        create(:task_instance, task_type: task_type_most_recent_completed, cycle: past_cycle, completed_bool: true, completed_date: 1.month.ago)

        # Current cycle instances
        create(:task_instance, task_type: task_type_least_recent_incomplete, cycle: current_cycle, completed_bool: false)
        create(:task_instance, task_type: task_type_most_recent_incomplete, cycle: current_cycle, completed_bool: false)
        create(:task_instance, task_type: task_type_least_recent_completed, cycle: current_cycle, completed_bool: true, completed_date: Date.today)
        create(:task_instance, task_type: task_type_most_recent_completed, cycle: current_cycle, completed_bool: true, completed_date: Date.today)
      end

      it 'sorts incomplete tasks first by previous_completion_date ascending, then completed tasks by previous_completion_date ascending' do
        get :index

        task_types_order = controller.instance_variable_get(:@task_instances_by_type).keys
        expected_order = [ task_type_least_recent_incomplete, task_type_most_recent_incomplete, task_type_least_recent_completed, task_type_most_recent_completed ]

        expect(task_types_order).to eq(expected_order)
      end
    end

    context 'with nil previous_completion_date' do
      let!(:task_type_nil_date) { create(:task_type) }
      let!(:task_type_with_date) { create(:task_type) }

      before do
        create(:task_instance, task_type: task_type_with_date, cycle: past_cycle, completed_bool: true, completed_date: 1.month.ago)
        create(:task_instance, task_type: task_type_nil_date, cycle: current_cycle, completed_bool: false)
        create(:task_instance, task_type: task_type_with_date, cycle: current_cycle, completed_bool: false)
      end

      it 'places nil dates after dated ones in their group' do
        get :index

        task_types_order = controller.instance_variable_get(:@task_instances_by_type).keys
        # task_type_with_date should come before task_type_nil_date in incomplete group
        expect(task_types_order.index(task_type_with_date)).to be < task_types_order.index(task_type_nil_date)
      end
    end
  end
end
