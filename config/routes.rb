Rails.application.routes.draw do
  devise_for :users
  root to: 'users#online'
end