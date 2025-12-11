module Admin
  class TaskTypesController < ApplicationController
    def index
      @task_types = TaskType.all.order(:id)
    end

    def database_view
      @task_types = TaskType.all.order(:id)
      @columns = TaskType.column_names
    end

    def new
      @task_type = TaskType.new
    end

    def create
      @task_type = TaskType.new(task_type_params)
      if @task_type.save
        redirect_to admin_task_types_path, notice: "Task type created."
      else
        render :new
      end
    end

    def edit
      @task_type = TaskType.find(params[:id])
    end

    def update
      @task_type = TaskType.find(params[:id])
      if @task_type.update(task_type_params)
        redirect_to admin_task_types_path, notice: "Task type updated."
      else
        render :edit
      end
    end

    def destroy
      @task_type = TaskType.find(params[:id])
      if @task_type.destroy
        redirect_to admin_task_types_path, notice: "Task type deleted."
      else
        redirect_to admin_task_types_path, alert: "Cannot delete task type: it has associated task instances."
      end
    rescue ActiveRecord::DeleteRestrictionError => e
      redirect_to admin_task_types_path, alert: "Cannot delete task type: it has associated task instances."
    end

    private

    def task_type_params
      params.require(:task_type).permit(:name, :description, :times_per_cycle, monthly_counts: {})
    end
  end
end
