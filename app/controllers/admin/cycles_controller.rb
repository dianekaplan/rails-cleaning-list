module Admin
  class CyclesController < ApplicationController
    def index
      @cycles = Cycle.order(end_date: :desc)
    end

    def new
      @cycle = Cycle.new
    end

    def create
      @cycle = Cycle.new(cycle_params)
      if @cycle.save
        redirect_to admin_cycles_path, notice: "Cycle created and task instances generated."
      else
        render :new
      end
    end

    def extend_week
      @cycle = Cycle.find(params[:id])
      @cycle.end_date = @cycle.end_date + 1.week
      if @cycle.save
        redirect_to admin_cycles_path, notice: "Cycle extended by one week."
      else
        redirect_to admin_cycles_path, alert: "Failed to extend cycle."
      end
    end

    private

    def cycle_params
      params.require(:cycle).permit(:start_date, :end_date)
    end
  end
end
