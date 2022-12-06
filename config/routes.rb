Rails.application.routes.draw do
  get 'new' => 'benefits_applications#new'
  post 'create' => 'benefits_applications#create'

  get 'new_primary_member' => 'benefits_applications#new_primary_member'
  post 'create_primary_member' => 'benefits_applications#create_primary_member'

  # get 'benefits_applications/new', as: :new_benefit_app
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "benefits_applications#index"
end
