Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :recipes
      get '/me', to: 'users#show'
      scope 'auth' do
        post '/signup', to: 'auth#signup'
        post '/login', to: 'auth#login'
      end
    end
  end

  mount ActionCable.server => '/cable'
end
