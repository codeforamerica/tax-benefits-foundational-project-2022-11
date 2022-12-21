require 'rails_helper'

RSpec.describe BenefitsApplicationsController, type: :controller do
  render_views

  describe "#index" do
    let!(:first_app)  { create :benefit_app, email_address: "app+1@codeforamerica.org", primary_member: build(:primary_member) }
    let!(:second_app) { create :benefit_app, email_address: "app+2@codeforamerica.org", primary_member: build(:primary_member) }

    it "shows a list of apps" do
      get :index

      expect(response.body).to include first_app.primary_member.first_name
      expect(response.body).to include second_app.primary_member.last_name
    end

    it "shows a link to the new application page and confirming page is rendered" do
      get :index

      expect(response.body).to include new_benefit_app_path
    end

    it "shows no name for benefit apps with no primary member" do
      incomplete_app = create(:benefit_app, primary_member: nil)
      get :index
      expect(response.body).to include "Not Submitted"
      expect(response.body).to include "No Primary Member"
    end
  end

  describe "#new" do
    it "provides a form to create a new benefit app" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response.body).to include "What's your address?"
    end
  end

  describe "#new_member" do
    let(:benefit_app) { create(:benefit_app, primary_member: nil) }
    let(:benefit_app_with_primary) {create(:benefit_app_with_primary_member)}

    it "provides a form to create a new primary member" do
      get :new_member, session: {benefit_app_id: benefit_app.id}

      expect(response).to have_http_status(:ok)
      expect(response.body).to include "What's your first name?"
    end

    it "adapts the view to create secondary members once a primary member exists" do
      get :new_member, session: {benefit_app_id: benefit_app_with_primary.id}

      expect(response).to have_http_status(:ok)
      expect(response.body).to include "What's your secondary member's first name?"
      expect(response.body).to include benefit_app_with_primary.primary_member.full_name
    end
  end

  describe "#create" do
    let(:params) { {benefit_app: {email_address: "Gary@Guava.com", phone_number: "8001002210", address: "1322 wallaby way"}} }
    let(:bad_params) { {benefit_app: {email_address: "invalid@", phone_number: "8001002211", address: "1322 wallaby way"}} }

    it "heads back to app listing on successful creation" do
      post :create, params: params
      expect(response).to redirect_to new_member_path
      expect(BenefitApp.all.length).to eq 1
      expect(BenefitApp.first.email_address).to eq "Gary@Guava.com"
    end

    it "shows validation errors on failure to create app" do
      post :create, params: bad_params
      expect(response).not_to redirect_to members_path
      expect(response.body).to include "Please enter a valid email address"
    end

    it "heads back to app listing on successful creation" do
      post :create, params: params
      expect(response).to redirect_to new_member_path
      expect(BenefitApp.all.length).to eq 1
      expect(BenefitApp.first.email_address).to eq "Gary@Guava.com"
    end

    it "shows validation errors on failure to create app" do
      post :create, params: bad_params
      expect(response).not_to redirect_to members_path
      expect(response.body).to include "Please enter a valid email address"
    end
  end

  describe "#create_member" do
    let(:benefit_app) { create(:benefit_app, primary_member: nil) }
    let(:primary_member_params) { attributes_for(:primary_member) }
    let(:secondary_members_params) { attributes_for_list(:secondary_member, 3) }

    it "creates a new primary member with the provided fields" do
      post :create_member, session: { benefit_app_id: benefit_app.id}, params: { member: primary_member_params }
      benefit_app.reload

      expect(response).to redirect_to new_member_path
      expect(benefit_app.primary_member).not_to be_nil
      expect(benefit_app.submitted_at).to be_nil
    end

    it "creates a new secondary member with the provided fields" do
      for member_param in secondary_members_params do
        post :create_member, session: { benefit_app_id: benefit_app.id }, params: { member: member_param }
        benefit_app.reload

        expect(response).to redirect_to new_member_path

        # get :new_member, session: {benefit_app_id: benefit_app.id}
        # expect(response.body).to include("#{member_param[:first_name]} #{member_param[:last_name]}")
      end
    end
  end

  describe "#validate_application" do
    let!(:valid_app)  { create :benefit_app, email_address: "app@codeforamerica.org", primary_member: build(:primary_member) }
    let!(:app_without_primary) { create(:benefit_app) }


    it "redirects to root url with a valid benefit app" do
      freeze_time do
        post :validate_application, session: { benefit_app_id: valid_app.id }
        expect(response).to redirect_to sign_benefits_app_path
        valid_app.reload
        expect(valid_app.submitted_at).to be_nil
        post :save_signature, session: { benefit_app_id: valid_app.id }, params: { benefit_app: { signature: "signed" } }
        valid_app.reload
        expect(valid_app.submitted_at).to eq Date.today
        expect(response).to redirect_to root_path
      end
    end

    it "does not redirect to root url without primary member" do
      post :validate_application, session: { benefit_app_id: app_without_primary.id }
      expect(response).not_to redirect_to root_path
    end

  end

  describe "#edit_member" do
    let(:benefit_app) { create(:benefit_app) }
    let(:primary_member_params) { attributes_for(:primary_member) }

    it "updates the primary member with provided edits" do
      post :create_member, session: { benefit_app_id: benefit_app.id}, params: { member: primary_member_params }
      benefit_app.reload
      expect(response).to redirect_to new_member_path

      get :edit_member, params: {id: benefit_app.primary_member.id}
      expect(response.body).to include("Edit Member")

      post :update_member, params: {id: benefit_app.primary_member.id, member: {first_name: "updated first name", last_name: "updated last name"} }
      expect(response).to redirect_to new_member_path

      get :new_member
      expect(response.body).to include("updated first name")
    end
  end

  describe "#delete_member" do
    let(:benefit_app) { create(:benefit_app, primary_member: build(:primary_member), secondary_members: build_list(:secondary_member, 3)) }

    it "fails to delete a non-existing member" do
      get :delete_member, session: {benefit_app_id: benefit_app.id}, params: { member_id: "nani"}
      benefit_app.reload

      expect(response).to redirect_to members_path
    end

    it "deletes an associated member" do
      member = benefit_app.secondary_members.last
      get :delete_member, session: {benefit_app_id: benefit_app.id}, params: { member_id: member.id.to_s}

      benefit_app.reload

      expect(benefit_app.secondary_members.count).to eql(2)
      expect(response).to redirect_to new_member_path
    end

  describe "#delete_benefit_app" do
    let(:params) { {benefit_app: {email_address: "Gary@Guava.com", phone_number: "8001002210", address: "1322 wallaby way"}} }
    # let(:benefit_app) { create(:benefit_app, primary_member: nil) }
    let(:primary_member_params) { attributes_for(:primary_member) }
    it "removes an existing record from the database which results in removal from the benefits apps index and associated members" do
      post :create, params: params
      benefits_apps = BenefitApp.all
      benefit_app = BenefitApp.first
      post :create_member, session: { benefit_app_id: benefit_app.id}, params: { member: primary_member_params }
      benefit_app.reload
      primary_member = benefit_app.primary_member
      delete :delete_benefit_app, params: { benefit_app_id: benefit_app.id }
      expect(response).to redirect_to root_path
      get :index
      expect(response.body).not_to include "#{primary_member.full_name}"
      new_benefits_apps = BenefitApp.all
      expect(benefits_apps.length == new_benefits_apps.length + 1)

    end

  end

  describe "#edit_benefits_application" do
    let(:benefit_app) { create(:benefit_app, primary_member: build(:primary_member), secondary_members: build_list(:secondary_member, 3)) }

    it "allows editing benefits applications and reflects edited information on index" do
      get :edit_benefits_app, params: {benefit_app_id: benefit_app.id}
      expect(response.body).to include("Edit Benefits Application")

      post :update_benefits_app, params: {benefit_app_id: benefit_app.id, benefit_app: { email_address: "update@codeforamerica.org" } }
      expect(response).to redirect_to new_member_path
      get :edit_benefits_app, params: {benefit_app_id: benefit_app.id}
      expect(response.body).to include("update@codeforamerica.org")
    end

    it "does not redirect or reflect updates with invalid params" do
      post :update_benefits_app, params: {benefit_app_id: benefit_app.id, benefit_app: { email_address: "123" } }
      expect(response).not_to redirect_to new_member_path
      get :edit_benefits_app, params: {benefit_app_id: benefit_app.id}
      expect(response.body).not_to include("123")

      post :update_benefits_app, params: {benefit_app_id: benefit_app.id, benefit_app: { email_address: "update@codeforamerica.org" } }
      expect(response).to redirect_to new_member_path
      get :edit_benefits_app, params: {benefit_app_id: benefit_app.id}
      expect(response.body).to include("update@codeforamerica.org")
    end

    it "does not redirect or reflect updates with invalid params" do
      post :update_benefits_app, params: {benefit_app_id: benefit_app.id, benefit_app: { email_address: "123" } }
      expect(response).not_to redirect_to root_path
      get :edit_benefits_app, params: {benefit_app_id: benefit_app.id}
      expect(response.body).not_to include("123")
    end

  end
    end
end