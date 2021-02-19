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
        member do
          get :posts
        end
      end
      resources :friend_requests, only: [:create, :update, :destroy]
      resources :posts, only: [:index, :show, :create] do
        resources :likes, only: [:create, :destroy]
        resources :comments, only: :create
      end
    end
  end
end
