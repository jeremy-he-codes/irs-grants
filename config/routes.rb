Rails.application.routes.draw do
  root 'home#index'
  get 'filers/:id', to: 'home#index'
  get 'filings/:id', to: 'home#index'
  get 'recipients', to: 'home#index'

  namespace :api do
    namespace :v1 do
      resources :filers, only: [:index, :show] do
        get 'filings', to: 'filings#index'
      end

      resources :filings, only: [:index, :show] do
        get 'awards', to: 'awards#index'
      end

      resources :awards, only: [:index, :show]
      resources :recipients, only: [:index, :show]
    end
  end
end
