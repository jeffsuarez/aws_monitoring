Rails.application.routes.draw do
  resources :sessions, only: [:new, :create]

  match 'logout', to: "sessions#destroy", via: "delete", defaults: { id: nil }

  root 'dashboard#show'
end
