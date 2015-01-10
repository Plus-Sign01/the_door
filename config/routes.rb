TheDoor::Application.routes.draw do

  root to: 'welcome#index'
  get '/login' => 'sessions#create', as: :login
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }


  get 'auth/:provider/callback', to: 'sessions#create'
  #get 'auth/failure', to: redirect('/')
  get '/logout', to: 'sessions#destroy', as: :logout
  resources :user do 

    get 'retire'


    
  end

  resources :projects do 
    resources :participations

    
  end

  

  end