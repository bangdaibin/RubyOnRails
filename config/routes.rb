Rails.application.routes.draw do


  get 'book/index'

  get 'book/new'

  get 'book/edit'

  get 'book/show'

  get 'publishers/index'

  get 'publishers/show'

  get 'publishers/new'

  get 'publishers/edit'

  get 'categories/new'

  get 'authors/new'

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get 'users/new'

  root 'books#index'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'

  # Add new routes for logging in/out
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end
   
  
  resources :users
  resources :books do
  resources :reviews
  end
  resources :publishers
  resources :authors
  resources :categories
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :relationships,       only: [:create, :destroy]
end