class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def withings
    @user = User.find_or_create_by_oauth request.env['omniauth.auth']

    unless @user.persisted?
      session['devise.withings_data'] = request.env['omniauth.auth']
      return redirect_to root_url
    end

    sign_in_and_redirect @user, event: :authentication

    @user.collect_movements

    set_flash_message :notice, :success, kind: 'Withings' if is_navigational_format?
  end
end
