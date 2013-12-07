class User < ActiveRecord::Base
  devise :rememberable, :omniauthable, omniauth_providers: [:withings]

  has_many :measurements

  def collect_movements
     Measurement.collect_most_recent_measurements_for self
     index_movements
  end

  def index_movements
    # measurements are returned with the most recent having an index of 0
    measurements.each_with_index do |after_measurement, i|
      before_measurement = measurements[i+1]
      Movement.find_or_create_by before_measurement: before_measurement, after_measurement: after_measurement
    end
  end

  def movements
    Movement.all.keep_if{|m| m.before_measurement.user_id == id}
  end

  def withings_user
    @withings_user ||= Withings::User.authenticate uid, key, secret
  end

  def set_withings_credentials(secret, token)
    assign_attributes secret: auth.credentials.secret, key: auth.credentials.token
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