require "rails_helper"

RSpec.feature "a user creating a new benefits application" do

    scenario "I can go through the flow of creating an application with benefits" do
      visit root_path
      click_on "New Application"
      expect(page).to have_text "How can we contact you?"
      fill_in "What's your address?", with: "13 wallaby way sydney"
      fill_in "What's your phone number?", with: "1234567891"
      fill_in "What's your email address?", with: "test@example.com"
      click_on "Continue →"

      expect(page).to have_text "Tell us about yourself"
      fill_in "What's your first name?", with: "first"
      fill_in "What's your last name?", with: "last"
      fill_in "What's your birthdate?", with: "03/12/1990"
      click_on "Add Member →"

      expect(page).to have_text "Tell us about your secondary member"
      expect(page).to have_text "first"
      expect(page).to have_text "last"

      fill_in "What's your secondary member's first name?", with: "first1"
      fill_in "What's your secondary member's last name?", with: "last1"
      fill_in "What's your secondary member's birthdate?", with: "03/10/1990"
      click_on "Add Member →"

      expect(page).to have_text "first1"
      expect(page).to have_text "last1"

      click_on "Continue →"

      expect(page).to have_text "Submitted Applications"
      expect(page).to have_text "first last"

    end
  end