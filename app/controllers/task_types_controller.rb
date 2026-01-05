class TaskTypesController < ApplicationController
  def repeat_completed_task_type
    task_type = TaskType.find(params[:id])
    current_cycle = Cycle.current_cycle
    TaskInstance.create!(
      task_type: task_type,
      cycle: current_cycle,
      completed_bool: true,
      completed_date: Date.today
    )
    redirect_to task_instances_path, notice: "Task repeated successfully."
  end
end
