Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  root 'static_pages#home'
  get '/help', to: 'static_pages#help' 
  get '/about', to: 'static_pages#about' 
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  
  delete '/logout',  to: 'sessions#destroy'
  get '/login', to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  
  get '/settings', to: 'users#edit'

  resources :users
end
