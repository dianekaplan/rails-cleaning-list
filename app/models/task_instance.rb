class TaskInstance < ActiveRecord::Base
  self.table_name = "task_instances"

  belongs_to :task_type
  belongs_to :cycle

  validates :completed_bool, inclusion: { in: [ true, false ] }
  validate :completed_date_when_completed

  def completed_date_when_completed
    return unless completed_bool
    errors.add(:completed_date, "can't be blank when completed") if completed_date.nil?
  end

  def mark_done!
    update!(completed_bool: true, completed_date: Date.today)
  end
end
