Rails.application.routes.draw do
  root to: "pages#home"
  
  resources :couches do
    resources :bookings, only: %i[new create] do
      resources :reviews, only: %i[new create]
    end
  end

  resources :bookings, only: %i[index show destroy]
  get 'couch/:couch_id/bookings/:id/sent', to: 'bookings#sent', as: 'sent'

  resources :cities, only: %i[index show]

  devise_for :users
end
