require 'rails_helper'

RSpec.describe "benefit app submissions", type: :system do
  before do
    driven_by(:rack_test)
  end

  context "for the benefit app" do
    pending "fails to create when a required param is missing"
    pending "is created"
  end

  context "for single filers" do
    it "creates a new app" do
      visit new_benefit_app_path
      benefit_app_params = attributes_for(:benefit_app)

      fill_in "What's your address?", with: benefit_app_params[:address]
      fill_in "What's your phone number?", with: benefit_app_params[:phone_number]
      fill_in "What's your email address?", with: benefit_app_params[:email_address]
      click_button "Continue"
      expect(page).to have_text("Tell us about yourself")

      primary_member_params = attributes_for(:member)
      fill_in "What's your first name?", with: primary_member_params[:first_name]
      fill_in "What's your last name?", with: primary_member_params[:last_name]
      fill_in "What's your birthdate?", with: primary_member_params[:date_of_birth]
      fill_in "What's your social security number (SSN)?", with: primary_member_params[:ssn]
      click_button "Add Member →"
      expect(page).to have_text("Tell us about your secondary member")
      click_on "Continue"

      full_name = "#{primary_member_params[:first_name]} #{primary_member_params[:last_name]}"
      expect(page).to have_text(full_name)
      expect(page).to have_text("Submitted Applications")
    end
  end
end
