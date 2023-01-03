Rails.application.routes.draw do
  get 'new' => 'benefits_applications#new', as: :new_benefit_app
  post 'create' => 'benefits_applications#create', as: :benefit_apps
  delete 'delete_benefit_app/:benefit_app_id' => 'benefits_applications#delete_benefit_app', as: :delete_benefit_app
  get 'new_member' => 'benefits_applications#new_member', as: :members
  post 'create_member' => 'benefits_applications#create_member'
  get 'validate_application' => 'benefits_applications#validate_application'

  patch 'update_member/:id', to: 'benefits_applications#update_member', as: :member
  get 'members/:id', to: 'benefits_applications#edit_member', as: 'edit_member'
  get 'benefits_apps/:benefit_app_id', to: 'benefits_applications#edit_benefits_app', as: :edit_benefits_app
  get 'delete_member/:member_id' => 'benefits_applications#delete_member', as: :delete_member
  patch 'update_benefits_apps/:benefit_app_id', to: 'benefits_applications#update_benefits_app', as: :update_benefits_app
  patch 'update_benefits_apps/:benefit_app_id', to: 'benefits_applications#update_benefits_app', as: :benefit_app
  root "benefits_applications#index"
end
