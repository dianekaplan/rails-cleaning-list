class TaskType < ActiveRecord::Base
    attribute :active, :boolean, default: true
  self.table_name = "task_types"

  # per-month counts stored as month-number string => integer
  attribute :monthly_counts, :json, default: {}
  attribute :times_per_cycle, :integer, default: 1

  has_many :task_instances, dependent: :restrict_with_error

  validates :name, presence: true
  validates :times_per_cycle, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :monthly_counts_values


  # return how many instances to create for a cycle in a given month
  # monthly_counts is used for tasks that can vary by month (e.g., seasonal tasks)
  # if that's empty, use times_per_cycle
  def times_for_cycle_that_month(month)
    return times_per_cycle.to_i if monthly_counts.blank?

    month_str = month.to_s
    return times_per_cycle.to_i if monthly_counts.key?(month_str) && monthly_counts[month_str].blank?
    return monthly_counts[month_str].to_i if monthly_counts.key?(month_str)

    0
  end

  # return the completion date from the most recent task_instance of this task_type
  def previous_completion_date
    current = Cycle.current_cycle
    task_instances
      .joins(:cycle)
      .where(completed_bool: true)
      .order("task_instances.completed_date DESC")
      .first&.completed_date
  end

  private

  def monthly_counts_values
    return if monthly_counts.nil?
    unless monthly_counts.is_a?(Hash)
      errors.add(:monthly_counts, "must be a hash mapping month->count")
      return
    end

    invalid_key = monthly_counts.keys.map(&:to_s).reject { |k| (1..12).include?(k.to_i) }
    errors.add(:monthly_counts, "keys must be month numbers 1..12") if invalid_key.any?

    invalid_val = monthly_counts.values.reject { |v| v.to_i >= 0 }
    errors.add(:monthly_counts, "values must be integers >= 0") if invalid_val.any?
  end
end
