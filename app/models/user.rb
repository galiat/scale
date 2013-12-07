class User < ActiveRecord::Base
  devise :rememberable, :omniauthable, omniauth_providers: [:withings]

  has_many :measurements

  def self.find_for_withings_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.nil?
      user = User.create(
                         provider: auth.provider,
                         uid: auth.uid,
                         secret: auth.credentials.secret,
                         key: auth.credentials.token)
    else
      #unfortunately these change each time the user authenticates
      user.update(secret: auth.credentials.secret, key: auth.credentials.token)
      user
    end
  end

  def movements
    Movement.all.keep_if{|m| m.before_measurement.user_id == id}
  end

end
