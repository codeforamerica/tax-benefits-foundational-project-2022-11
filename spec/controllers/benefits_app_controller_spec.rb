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

      expect(response.body).to include new_benefit_app_path
    end
  end

  describe "#new" do
    it "provides a form to create a new benefit app" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response.body).to include "What's your address?"
    end
  end

  describe "#new_primary_member" do
    let(:benefit_app) { create(:benefit_app, primary_member: nil) }

    it "provides a form to create a new primary member" do
      get :new_primary_member, session: {benefit_app_id: benefit_app.id}

      expect(response).to have_http_status(:ok)
      expect(response.body).to include "What's your first name?"
    end
  end

  describe "#create" do
    let(:params) { {benefit_app: {email_address: "Gary@Guava.com", phone_number: "94110", address: "1322 wallaby way"}} }
    let(:bad_params) { {benefit_app: {email_address: "invalid@", phone_number: "94110", address: "1322 wallaby way"}} }

    it "heads back to app listing on successful creation" do
      post :create, params: params
      expect(response).to redirect_to new_primary_member_path
      expect(BenefitApp.all.length).to eq 1
      expect(BenefitApp.first.email_address).to eq "Gary@Guava.com"
    end

    it "shows validation errors on failure to create app" do
      post :create, params: bad_params
      expect(response).not_to redirect_to new_primary_member_path
      expect(response.body).to include "is invalid"
    end
  end

  describe "#create_primary_member" do
    let(:benefit_app) { create(:benefit_app, primary_member: nil) }
    let(:member_params) { attributes_for(:member) }

    it "creates a new primary member with the provided fields" do
      freeze_time do
        post :create_primary_member, session: {benefit_app_id: benefit_app.id}, params: {member: member_params}
        benefit_app.reload

        expect(response).to redirect_to root_path
        expect(benefit_app.primary_member).not_to be_nil
        expect(benefit_app.submitted_at).not_to be_nil
        expect(benefit_app.submitted_at).to eq Date.today
      end
    end
  end
end