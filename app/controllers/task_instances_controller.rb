class TaskInstancesController < ApplicationController
  def index
    @latest_cycle = Cycle.order(:id).last
    @task_instances = if @latest_cycle
      TaskInstance.where(cycle: @latest_cycle).includes(:task_type).order(:id)
    else
      []
    end
  end

  def update
    @task_instance = TaskInstance.find(params[:id])
    if params[:mark_done]
      @task_instance.update(completed_bool: true, completed_date: Date.today)
      redirect_to root_path, notice: 'Marked done.'
    else
      if @task_instance.update(task_instance_params)
        redirect_to root_path, notice: 'Updated.'
      else
        redirect_to root_path, alert: 'Failed to update.'
      end
    end
  end

  private

  def task_instance_params
    params.require(:task_instance).permit(:completed_bool, :completed_date)
  end
end
