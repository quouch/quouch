Rails.application.routes.draw do
  root to: "pages#home"

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

  mount StripeEvent::Engine, at: '/stripe-webhooks'

  resources :cities, only: %i[index show]

  resources :chats, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  mount ActionCable.server => '/cable'


  devise_for :users, controllers: { registrations: 'users/registrations' }
end
