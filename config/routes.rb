Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'

  resources :users do
    member do
      get :following,:followers
    end
  end

  resources :sessions,only: [:new,:create,:destroy]
  resources :microposts,only: [:create, :destroy]
  resources :relationships, only:[:create,:destroy]
  root  'static_pages#home'
  match '/signup', to: 'users#new',  via: 'get'
  match '/help', to: 'static_pages#help', via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/signout',to:'sessions#destroy',    via: 'delete'
  match '/signin', to:'sessions#new',   via: 'get'
end