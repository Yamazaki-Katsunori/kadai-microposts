Rails.application.routes.draw do
    root to: 'toppages#index'
    
    get 'singup', to: 'users#new'
    resources :users, only: [:index, :show, :new, :create]
end
