require 'rails_helper'

RSpec.describe BenefitsApplicationsController, type: :controller do
  describe "#index" do
    let!(:first_app)  { create :benefit_app, email_address: "app+1@codeforamerica.org" }
    let!(:second_app) { create :benefit_app, email_address: "app+2@codeforamerica.org" }

    render_views

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
    end
    # Show the validation errors on the page
    # Redirect to list of apps and look for new app on page
  end
end