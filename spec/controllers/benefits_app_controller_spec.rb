require 'rails_helper'

RSpec.describe BenefitsApplicationsController, type: :controller do
  render_views

  describe "#index" do
    let!(:first_app)  { create :benefit_app, email_address: "app+1@codeforamerica.org" }
    let!(:second_app) { create :benefit_app, email_address: "app+2@codeforamerica.org" }

    it "shows a list of apps" do
      get :index

      # TODO: Check for app ID, applicant number and date submitted once
      #       those fields are available.

      expect(response.body).to include first_app.email_address
      expect(response.body).to include second_app.email_address
    end

    it "shows a link to the new application page and confirming page is rendered" do
      get :index

      expect(response.body).to include new_benefits_app_path
    end
  end

  describe "#new" do
    it "provides a form to create a new benefit app" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response.body).to include "What's your address?"
    end

    # Redirect to list of apps and look for new app on page
  end

  describe "#create" do

    let(:params) { {benefit_app: {email_address: "Gary@Guava.com", phone_number: "94110", address: "1322 wallaby way"}} }
    let(:bad_params) { {benefit_app: {email_address: "invalid@", phone_number: "94110", address: "1322 wallaby way"}} }

    it "heads back to app listing on successful creation" do
      post :create, params: params
      expect(response).to redirect_to root_path
    end

    it "shows validation errors on failure to create app" do
      post :create, params: bad_params
      expect(response).not_to redirect_to root_path
      expect(response.body).to include "is invalid"
    end
  end
end