class Cycle < ActiveRecord::Base
  self.table_name = 'cycles'

  has_many :task_instances, dependent: :restrict_with_error

  validates :start_date, presence: true
  validate :end_after_start

  after_create :generate_task_instances

  def self.current_cycle
    order(id: :desc).first
  end

  def generate_task_instances
    TaskType.find_each do |tt|
      count = tt.times_for_cycle_that_month(start_date.month)
      count.times do
        TaskInstance.create!(task_type: tt, cycle: self, completed_bool: false)
      end
    end
  end

  def end_after_start
    return if end_date.nil?
    errors.add(:end_date, 'must be after start_date') if end_date < start_date
  end
end
