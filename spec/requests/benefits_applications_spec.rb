require 'rails_helper'

RSpec.describe "BenefitsApplications", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/benefits_applications/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/benefits_applications/new"
      expect(response).to have_http_status(:success)
    end
  end

end
