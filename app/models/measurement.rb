class Measurement < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :weight, presence: true
  validates :taken_at, presence: true

  default_scope order('taken_at DESC')

  def self.collect_most_recent_measurements_for(user)
    measurements_after = user.measurements.first.taken_at + 1.second #need to +1 to not include the last measurement
    measurement_groups = user.withings_user.measurement_groups device: Withings::SCALE, per_page: 0, start_at: measurements_after
    measurement_groups.each{|m| Measurement.where(user_id: user.id, weight: m.weight, taken_at: m.taken_at).first_or_create}
  end
end
