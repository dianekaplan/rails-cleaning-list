class TaskInstancesController < ApplicationController
  def index
    @latest_cycle = Cycle.current_cycle
    @task_instances = if @latest_cycle
      TaskInstance.where(cycle: @latest_cycle).includes(:task_type).order(:id)
    else
      []
    end

    @task_instances_by_type = @task_instances.group_by(&:task_type)

    # Sort task types: incomplete first, then completed, both by previous_completion_date ascending
    @task_instances_by_type = @task_instances_by_type.sort_by do |task_type, instances|
      has_incomplete_instances = instances.any? { |ti| !ti.completed_bool }
      primary_sort_key = has_incomplete_instances ? 0 : 1  # 0 = incomplete (show first), 1 = completed
      secondary_sort_key = task_type.previous_completion_date || Date.new(9999)  # Ascending date; nil dates last
      [ primary_sort_key, secondary_sort_key ]
    end.to_h

    if @latest_cycle
      @tasks_remaining = @task_instances.where(completed_bool: false).count
      @days_remaining = (@latest_cycle.end_date - Date.today).to_i + 1
    end
  end

  def update
    @task_instance = TaskInstance.find(params[:id])
    if params[:mark_done]
      @task_instance.update(completed_bool: true, completed_date: Date.today)
      redirect_to root_path, notice: "Marked done."
    else
      if @task_instance.update(task_instance_params)
        redirect_to root_path, notice: "Updated."
      else
        redirect_to root_path, alert: "Failed to update."
      end
    end
  end

  private

  def task_instance_params
    params.require(:task_instance).permit(:completed_bool, :completed_date)
  end
end
