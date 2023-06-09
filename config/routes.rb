Rails.application.routes.draw do

  
  resources :carts, except:[:index, :new, :edit]
  resources :cart_items, only:[:create, :update, :destroy]

  devise_for :users do
    resources :orders, only: [:new, :create]
  end
  
  resources :users, only:[:show]
  resources :items

  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'success', to: 'checkout#success', as: 'checkout_success'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
  end

  root "items#index"
end
