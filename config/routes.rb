Rails.application.routes.draw do
  devise_for :users
  root to: 'users#online'

  devise_scope :user do
    get "logout" => "devise/sessions#destroy"
  end
end
