require 'rails_helper'

RSpec.describe TaskTypesController, type: :controller do
  describe 'POST #repeat_completed_task_type' do
    let(:task_type) { create(:task_type) }
    let(:current_cycle) { create(:cycle) }

    before do
      allow(Cycle).to receive(:current_cycle).and_return(current_cycle)
    end

    context 'with valid task_type' do
      it 'creates a new TaskInstance' do
        expect {
          post :repeat_completed_task_type, params: { id: task_type.id }
        }.to change(TaskInstance, :count).by(1)
      end

      it 'associates the TaskInstance with the task_type and current cycle' do
        post :repeat_completed_task_type, params: { id: task_type.id }
        task_instance = TaskInstance.last
        expect(task_instance.task_type).to eq(task_type)
        expect(task_instance.cycle).to eq(current_cycle)
        expect(task_instance.completed_bool).to be_truthy
        expect(task_instance.completed_date.to_date).to eq(Date.today)
      end

      it 'redirects to task_instances_path with success notice' do
        post :repeat_completed_task_type, params: { id: task_type.id }
        expect(response).to redirect_to(task_instances_path)
        expect(flash[:notice]).to eq('Task repeated successfully.')
      end
    end

    context 'with invalid task_type id' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          post :repeat_completed_task_type, params: { id: 999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
