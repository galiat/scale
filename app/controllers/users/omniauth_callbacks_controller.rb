class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def withings
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_withings_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Withings") if is_navigational_format?
    else
      session["devise.withings_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
