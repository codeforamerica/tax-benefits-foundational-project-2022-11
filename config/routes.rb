Rails.application.routes.draw do
  get 'new_benefits_app' => 'benefits_applications#new'
  # get 'benefits_applications/new', as: :new_benefit_app
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "benefits_applications#index"
end
