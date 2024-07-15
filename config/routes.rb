Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", :as => "rails_admin"

  authenticated :user do
    root "couches#index", as: :authenticated_root
  end

  root "pages#home"

  get "/search_cities", to: "couches#search_cities"
  get "/about", to: "pages#about"
  get "/faq", to: "pages#faq"
  get "/guidelines", to: "pages#guidelines"
  get "/impressum", to: "pages#impressum"
  get "/privacy", to: "pages#privacy"
  get "/safety", to: "pages#safety"
  get "/terms", to: "pages#terms"
  get "/invite-code", to: "invites#invite_code_form"
  get "/validate-invite-code", to: "invites#validate_invite_code"
  get "/invite-friend", to: "invites#invite_friend"
  get "/email-export", to: "pages#emails"

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
      get :show_request, as: "request"
      get :sent
      get :confirmed
      patch :complete
      patch :accept
      patch :decline
      patch :decline_and_send_message
      delete :cancel
    end
  end

  resources :chats, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  resources :contacts, only: %i[new create] do
    collection do
      get :code
      get :report
    end
  end

  resources :subscriptions, only: %i[new show create update destroy] do
    get :payment, on: :collection, defaults: {format: "html"}
  end

  mount ActionCable.server => "/cable"
  mount StripeEvent::Engine, at: "/stripe-webhooks"

  devise_for :users, controllers: {registrations: "users/registrations"}

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/422", to: "errors#unprocessable_content", via: :all

  # API Endpoints
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      # Configure devise to work with the API endpoints
      devise_scope :user do
        get "login", to: "users/sessions#new"
        post "login", to: "users/sessions#create"
        delete "logout", to: "users/sessions#destroy"

        get "users/edit" => "users/registrations#edit"

        post "update/:id", to: "users/registrations#update"
        # Do we want to enable creating and updating user data?
        #   get 'api/auth/signup', to: 'users/registrations#new'
        #   post 'api/auth/signup', to: 'users/registrations#create'
        #   put 'api/auth/update', to: 'users/registrations#update'
      end

      resources :couches, only: %i[index show create destroy]
      resources :users, only: %i[index show]
    end
  end
end
