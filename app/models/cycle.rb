class Cycle < ActiveRecord::Base
  self.table_name = "cycles"

  has_many :task_instances, dependent: :destroy

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_after_start

  after_create :generate_task_instances

  def self.current_cycle
    order(end_date: :desc).first
  end

  def generate_task_instances
    TaskType.where(active: true).find_each do |tt|
      count = tt.times_for_cycle_that_month(start_date.month)

      if count <= 0
        Rails.logger.info("[Cycle##{id}] No task instances requested for task type #{tt.name} (#{tt.id}) in month #{start_date.month}")
        next
      end

      Rails.logger.info("[Cycle##{id}] Creating #{count} task instance(s) for task type #{tt.name} (#{tt.id}) in month #{start_date.month}")

      count.times do |index|
        begin
          TaskInstance.create!(task_type: tt, cycle: self, completed_bool: false)
        rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
          Rails.logger.error("[Cycle##{id}] Failed to create task instance #{index + 1}/#{count} for task type #{tt.name} (#{tt.id}) in month #{start_date.month}: #{e.message}")
          raise
        end
      end
    end
  end

  def end_after_start
    return if end_date.nil?
    errors.add(:end_date, "must be after start_date") if end_date < start_date
  end
end
