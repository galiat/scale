class Movement < ActiveRecord::Base
  belongs_to :before_measurement, class_name: 'Measurement'
  belongs_to :after_measurement, class_name: 'Measurement'

  def happened_at
    before_measurement.taken_at
  end

  def duration
    after_measurement.taken_at - before_measurement.taken_at
  end

  def weight
    before_measurement.weight - after_measurement.weight
  end

  def weight_pounds
    weight * 2.20462
  end

  def self.is_movement(m_before, m_after)
    if m_before && m_after
      user_ok = m_before.user_id == m_after.user_id
      time_ok = m_after.taken_at - m_before.taken_at < 10.minutes
      weight_ok = m_before.weight > m_after.weight
      time_ok && weight_ok && user_ok
    else
      false
    end
  end
end
