Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'
  get '/people', to: 'relationships#index'

  get '/my_queue', to: 'queue_items#index'

  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  resources :queue_items, only: [:create, :destroy]
  post '/update_queue', to: 'queue_items#update_queue'
  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]
  resources :relationships, only: [:create, :destroy]
end
