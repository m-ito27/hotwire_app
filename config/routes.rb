Rails.application.routes.draw do
  devise_for :users
  resources :todos, only: %i[index create update destroy]

  get "up" => "rails/health#show", as: :rails_health_check

  root "todos#index"
end
