Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'

  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
  end
  resources :categories, only: [:show]
end
