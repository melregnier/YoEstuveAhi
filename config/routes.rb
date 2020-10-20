Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :locations, only: [:show, :index, :create, :new]
  resources :users, only: [:show, :create, :new]

  get '' => redirect('/home')
  get 'welcome', to: 'sessions#welcome'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  scope '/tests' do
    get '', to: 'covid_tests#index'

    get 'positive', to: 'covid_tests#new_positive'
    get 'negative', to: 'covid_tests#new_negative'

    post 'positive', to: 'covid_tests#create_positive'
    post 'negative', to: 'covid_tests#create_negative'
  end

  get 'home', to: 'home#index'

  get 'qr/checkin', to: 'user_locations#new_checkin'
  get 'qr/checkout', to: 'user_locations#new_checkout'
  delete 'user_location', to: 'user_locations#destroy'

  resources :user_locations, only: :create
end