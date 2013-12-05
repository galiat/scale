class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require 'withings'
  def withings
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_withings_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated

      Withings.consumer_key = ENV['WITHINGS_APP_ID']
      Withings.consumer_secret =  ENV['WITHINGS_APP_SECRET']

      wi_user = Withings::User.authenticate(@user.uid, @user.key, @user.secret)
      measurement_groups = wi_user.measurement_groups(:device => Withings::SCALE, :limit => 1000)

      measurement_groups.each{|m| Measurement.create(user_id: @user.id, weight: m.weight, taken_at:m.taken_at)}
      @user.measurements.each_with_index do |after_measurement,i|
        before_measurement = @user.measurements[i+1]
        movement = Movement.new before_measurement_id: m_before.id, after_measurement_id: after_measurement.id
        if movement.valid?
          movement.save #TODO handle if save fails
        end
      end

      set_flash_message(:notice, :success, :kind => "Withings") if is_navigational_format?
    else
      session["devise.withings_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
