Rails.application.routes.draw do
  devise_for :users
  resources :todos, only: %i[index create update destroy]

  get "up" => "rails/health#show", as: :rails_health_check

  # Development only: user list for quick login
  if Rails.env.development?
    get "userlist", to: "dev_users#index"
    post "dev_users/:id/login", to: "dev_users#login", as: :dev_user_login
  end

  root "todos#index"
end
