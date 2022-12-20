Rails.application.routes.draw do
  get 'new' => 'benefits_applications#new', as: :new_benefit_app
  post 'create' => 'benefits_applications#create'

  get 'new_member' => 'benefits_applications#new_member'
  post 'create_member' => 'benefits_applications#create_member'
  get 'validate_application' => 'benefits_applications#validate_application'
  get 'edit_member' => 'benefits_applications#edit_member'

  # get 'benefits_applications/new', as: :new_benefit_app
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "benefits_applications#index"
end
