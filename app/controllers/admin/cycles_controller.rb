module Admin
  class CyclesController < ApplicationController
    def index
      @cycles = Cycle.order(:id)
    end

    def new
      @cycle = Cycle.new
    end

    def create
      @cycle = Cycle.new(cycle_params)
      if @cycle.save
        redirect_to admin_cycles_path, notice: 'Cycle created and task instances generated.'
      else
        render :new
      end
    end

    private

    def cycle_params
      params.require(:cycle).permit(:start_date, :end_date)
    end
  end
end
