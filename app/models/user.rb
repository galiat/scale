class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
  omniauth_providers: [:withings]
  
  def self.find_for_withings_oauth(auth, signed_in_resource=nil)
    logger.debug auth.to_s 
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      user = User.create(name: auth.uid,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: 'string@mail.com',
                         password: Devise.friendly_token[0,20])

    end
  end
end
