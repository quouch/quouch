Rails.application.routes.draw do
  root to: 'pages#home'

  get '/about', to: 'pages#about'
  get '/faq', to: 'pages#faq'
  get '/guidelines', to: 'pages#guidelines'
  get '/impressum', to: 'pages#impressum'
  get '/privacy', to: 'pages#privacy'

  resources :couches, only: %i[index show] do
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
      delete :cancel
    end
    resources :payments, only: %i[new]
  end

  mount StripeEvent::Engine, at: '/update-payment'

  resources :cities, only: %i[show] do
    member do
      get :couches
    end
  end

  resources :chats, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  resources :contacts, only: %i[new create]

  mount ActionCable.server => '/cable'

  # namespace :api, defaults: { format: :json } do
  #   namespace :v1 do
  #     resources :chats, only: %i[index show create] do
  #       resources :messages, only: %i[create]
  #     end
  #   end
  # end


  devise_for :users, controllers: { registrations: 'users/registrations' }
end
