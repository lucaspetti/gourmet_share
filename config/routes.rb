Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :recipes
      resources :users, only: [:show, :create, :update, :destroy]
      post '/login', to: 'authentication#login'
    end
  end

  mount ActionCable.server => '/cable'
end
