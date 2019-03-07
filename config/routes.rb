Rails.application.routes.draw do
  # makes home_index_path route available
  get 'home/index', to: 'home#index'
  # maps /admin route to index method of AdminController
  get '/admin', to: 'admin#index'
  
  # site resources
  resources :posts
  
  # set root path of site
  root 'home#index'
end
