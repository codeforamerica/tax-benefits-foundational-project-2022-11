Rails.application.routes.draw do
  get 'new' => 'benefits_applications#new', as: :new_benefit_app
  post 'create' => 'benefits_applications#create'

  get 'new_member' => 'benefits_applications#new_member'
  post 'create_member' => 'benefits_applications#create_member'
  get 'validate_application' => 'benefits_applications#validate_application'
  patch 'update_member/:id/update', to: 'benefits_applications#update_member', as: 'update_member'
  get 'members/:id/edit', to: 'benefits_applications#edit_member', as: 'edit_member'
  root "benefits_applications#index"
end
