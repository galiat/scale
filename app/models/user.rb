class User < ActiveRecord::Base
  devise :rememberable, :omniauthable, omniauth_providers: [:withings]

  has_many :measurements

  def average_weight
    movements.map{|m| m.weight}.sum / movements.count
  end

  def average_weight_pounds
    average_weight * 2.20462 #TODO externize convertions
  end

  def average_duration
    movements.map{|m| m.duration}.sum / movements.count
  end

  #TODO ['Morning', 'Day?','Afternoon', 'Evening', 'Late Night', 'Witching Hour']
  #def mode_time_of_day
  #end

  def collect_movements
     Measurement.collect_most_recent_measurements_for self
     index_movements
  end

  def index_movements
    # measurements are returned with the most recent having an index of 0
    measurements.each_with_index do |after_measurement, i|
      before_measurement = measurements[i+1]

      #TODO why .try ?
      Movement.find_or_create_by before_measurement_id: before_measurement.try(:id), after_measurement: after_measurement
    end
  end

  def movements
    @movements ||= Movement.all.keep_if{|m| m.user.id == id}
  end

  def withings_user
    @withings_user ||= Withings::User.authenticate uid, key, secret
  end

  def set_withings_credentials(secret, token)
    assign_attributes secret: secret, key: token
  end

  def self.find_or_create_by_oauth(auth)
    user = User.find_or_initialize_by uid: auth.uid do |u|
      u.set_withings_credentials auth.credentials.secret, auth.credentials.token

      #key & secret must be set first
      u.first_name = u.withings_user.first_name
      u.last_name = u.withings_user.last_name
    end

    #these change each time a user logs in
    user.set_withings_credentials auth.credentials.secret, auth.credentials.token

    user.save

    user
  end

end