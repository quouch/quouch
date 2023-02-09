Rails.application.routes.draw do
  root to: 'pages#home'
  get '/impressum', to: 'pages#impressum'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'

  resources :couches do
    resources :bookings, only: %i[new create] do
      collection do
        get :requests
      end

      resources :reviews, only: %i[new create]
    end
  end

  resources :bookings, only: %i[index show destroy edit update] do
    member do
      get :show_request, as: 'request'
      get :sent
      get :confirmed
      get :pay
      patch :accept
      patch :decline
      patch :cancel
    end
    resources :payments, only: %i[new]
  end

  mount StripeEvent::Engine, at: '/update-payment'

  resources :cities, only: %i[index show] do
    member do
      get :couches
    end
  end

  resources :chats, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  mount ActionCable.server => '/cable'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :chats, only: [ :index, :show, :create ]
    end
  end


  devise_for :users, controllers: { registrations: 'users/registrations' }
end
