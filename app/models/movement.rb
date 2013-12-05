class Movement < ActiveRecord::Base
  belongs_to :before_measurement, class_name: 'Measurement'
  belongs_to :after_measurement, class_name: 'Measurement'

  validates :before_measurement, presence: true
  validates :after_measurement, presence: true
  validate :same_user
  validate :time_range
  validate :weight_decrease

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

private

  def same_user
    if before_measurement.user_id != after_measurement.user_id
       errors.add :base, 'Users must be the same.'
    end
  end

  def time_range
    if after_measurement.taken_at < before_measurement.taken_at
       errors.add :base, 'before_measurement must be taken before the after_measurement.'
    elsif after_measurement.taken_at - before_measurement.taken_at >= 10.minutes #TODO externalize 10
       errors.add :base, 'Measurements must be less than 10 minutes apart.'
    end
  end

  def weight_decrease
    if before_measurement.weight < after_measurement.weight
      errors.add :base, 'Weight cannot increase.'
    end
  end

end
