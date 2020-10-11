Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :locations, only: [:show, :index, :create, :new]
  resources :users, only: [:show, :create, :new]

  get 'welcome', to: 'sessions#welcome'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'home', to: 'home#index'
end
