Scale::Application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  devise_scope :user do
    # Create our own sign out route pointing to devise's controller.
    delete "/users/sign_out" => "devise/sessions#destroy"
  end
  resources :users, only: 'show'
  resources :movements, only: 'index'

  root to: 'movements#index'
end
