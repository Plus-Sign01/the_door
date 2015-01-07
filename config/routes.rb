Rails.application.routes.draw do

  root to: 'welcome#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/login' => 'sessions#create', as: :login
  get '/logout' => 'sessions#destroy', as: :logout
  get '/auth/facebook'

  resources :user do 
    get 'retire'


    
  end

  resources :projects do 
    resources :participations

    
  end

  

  end