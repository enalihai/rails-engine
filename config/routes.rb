Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      namespace :merchants do
        resources :find, only: [:show], controller: :search_merchants
        resources :find_all, only: [:index], controller: :search_merchants
      end

      resources :items do
        resources :merchant, only: [:index], controller: :item_merchants
      end

      namespace :items do
        resources :find, only: [:show], controller: :search_items
        resources :find_all, only: [:index], controller: :search_items
      end
    end
  end
end
