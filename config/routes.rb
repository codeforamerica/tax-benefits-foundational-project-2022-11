Rails.application.routes.draw do
  get 'new' => 'benefits_applications#new', as: :new_benefit_app
  post 'create' => 'benefits_applications#create'

  get 'new_member' => 'benefits_applications#new_member'
  post 'create_member' => 'benefits_applications#create_member'
  post 'validate_application' => 'benefits_application#validate_application'

  # get 'benefits_applications/new', as: :new_benefit_app
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "benefits_applications#index"
end
