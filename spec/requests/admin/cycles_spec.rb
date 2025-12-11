require 'rails_helper'

RSpec.describe "Admin::Cycles", type: :request do
  describe "DELETE /admin/cycles/:id" do
    let!(:task_type) { TaskType.create!(name: 'Test Task', times_per_cycle: 1) }

    context "when deleting a non-current cycle" do
      it "successfully deletes the cycle and its task instances" do
        cycle1 = Cycle.create!(start_date: Date.new(2025, 1, 1), end_date: Date.new(2025, 1, 31))
        cycle2 = Cycle.create!(start_date: Date.new(2025, 2, 1), end_date: Date.new(2025, 2, 28))

        expect {
          delete admin_cycle_path(cycle1)
        }.to change(Cycle, :count).by(-1)
          .and change(TaskInstance, :count).by(-1)

        expect(response).to redirect_to(admin_cycles_path)
        expect(flash[:notice]).to eq("Cycle deleted.")
      end
    end

    context "when deleting the current cycle" do
      it "deletes the cycle and updates the current cycle" do
        cycle1 = Cycle.create!(start_date: Date.new(2025, 1, 1), end_date: Date.new(2025, 1, 31))
        cycle2 = Cycle.create!(start_date: Date.new(2025, 2, 1), end_date: Date.new(2025, 2, 28))

        expect(Cycle.current_cycle).to eq(cycle2)

        delete admin_cycle_path(cycle2)

        expect(response).to redirect_to(admin_cycles_path)
        expect(flash[:notice]).to include("Cycle deleted. Current cycle is now")
        expect(flash[:notice]).to include("01/01/2025")
        expect(Cycle.current_cycle).to eq(cycle1)
      end
    end

    context "when deleting the last cycle" do
      it "successfully deletes and shows appropriate message" do
        cycle = Cycle.create!(start_date: Date.new(2025, 1, 1), end_date: Date.new(2025, 1, 31))

        delete admin_cycle_path(cycle)

        expect(response).to redirect_to(admin_cycles_path)
        expect(Cycle.count).to eq(0)
        expect(Cycle.current_cycle).to be_nil
      end
    end
  end
end
