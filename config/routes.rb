Rails.application.routes.draw do
  get 'benefits_applications/index'
  get 'benefits_applications/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "homepage#index"
end
