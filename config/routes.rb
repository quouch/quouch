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

  resources :chats, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  resources :contacts, only: %i[new create]

  mount ActionCable.server => '/cable'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/422', to: 'errors#unprocessable_content', via: :all
end
