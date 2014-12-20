Rails.application.routes.draw do
  

  resources :projects

  get 'static_pages/home'

  get 'static_pages/help'
  get 'static_pages/about'
  get 'pages/home'
  root 'pages#home'
  get 'pages/render_demo'
  get 'pages/redirect_demo'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout


  end