class Movement < ActiveRecord::Base
  belongs_to :before_measurement, class_name: 'Measurement'
  belongs_to :after_measurement, class_name: 'Measurement'
  has_one :user, through: :before_measurement

  validates :before_measurement, presence: true
  validates :after_measurement, presence: true
  validate :same_user
  validate :time_range
  validate :weight_decrease

  default_scope joins(:before_measurement).order('taken_at DESC').readonly(false)

  def happened_at
    before_measurement.taken_at
  end

  def duration
    @duration ||= after_measurement.taken_at - before_measurement.taken_at
  end

  def weight
    @weight ||= before_measurement.weight - after_measurement.weight
  end

  def weight_pounds
    @weight_pounds ||= weight * 2.20462 #TODO externize convertions
  end

  #TODO
  #def mode_time_of_day
  #end


  private

  def same_user
    if measurements_present? && before_measurement.user_id != after_measurement.user_id
       errors.add :base, 'Users must be the same.'
    end
  end

  def time_range
    if measurements_present? && after_measurement.taken_at < before_measurement.taken_at
       errors.add :base, 'before_measurement must be taken before the after_measurement.'
    elsif measurements_present? && duration >= 10.minutes #TODO externalize 10
       errors.add :base, 'Measurements must be less than 10 minutes apart.'
    elsif measurements_present? && duration < 30.seconds
      errors.add :base, 'That was fast! Measurements must be more than 30 seconds apart.'
    end
  end

  def weight_decrease
    if measurements_present? && before_measurement.weight <= after_measurement.weight
      errors.add :base, 'Weight should decrease.'
    end
  end

  def measurements_present? #TODO ideally, I'd like to say run presence validations. If those pass, run these.
    @measurements_present ||= before_measurement && after_measurement
  end

end
