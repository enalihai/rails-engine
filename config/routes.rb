Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end
      resources :items do
        resources :merchant, only: [:index], controller: :item_merchants
      end
    end
  end
end
