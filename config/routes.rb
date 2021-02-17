Rails.application.routes.draw do
  get 'private/test'
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        resources :notifications, only: [:update, :destroy]
      end
      resources :friend_requests, only: [:create, :update, :destroy]
      resources :posts, only: [:index, :show, :create]
    end
  end
end
