require "rails_helper"

RSpec.feature "a user creating a new benefits application" do

  def create_application
    visit root_path
    click_on "New Application"
    expect(page).to have_text "How can we contact you?"
    fill_in "What's your address?", with: "13 wallaby way sydney"
    fill_in "What's your phone number?", with: "1234567891"
    fill_in "What's your email address?", with: "test@example.com"
    click_on "Continue →"
  end

  def add_primary_member(submit=false)
    fill_in "What's your first name?", with: "first"
    fill_in "What's your last name?", with: "last"
    fill_in "What's your birthdate?", with: "03/12/1990"
    click_on "Add Member →"
    if submit
      click_on "Continue →"
      fill_in "By entering your name you agree that you want to apply for benefits, that you have been honest on this application, and that you have read and agreed to the terms.", with: "signature"
      click_on "Sign and submit application"
    end
  end

  def add_secondary_member(submit=false)
    fill_in "What's your secondary member's first name?", with: "first1"
    fill_in "What's your secondary member's last name?", with: "last1"
    fill_in "What's your secondary member's birthdate?", with: "03/10/1990"
    click_on "Add Member →"
    if submit
      click_on "Continue →"
      fill_in "signature box", with: "signature"
      click_on "Sign and submit application"
    end
  end

    scenario "I can go through the flow of creating a benefits application with members" do
      create_application

      add_primary_member

      expect(page).to have_text "Tell us about your secondary member"
      expect(page).to have_text "first"
      expect(page).to have_text "last"

      add_secondary_member

      expect(page).to have_text "first1"
      expect(page).to have_text "last1"

      click_on "Continue →"

      expect(page).to have_text "Type your full legal name here"

      click_on "Sign and submit application"

      expect(page).to have_text "Submitted Applications"
      expect(page).to have_text "first last"

    end
  scenario "I can edit primary members but not delete" do
    create_application
    add_primary_member
    expect(page).not_to have_text "Delete"
    click_on "Edit"

    expect(page).to have_text "Edit Member"
    expect(page).to have_text "first"
    expect(page).to have_text "last"

    fill_in "What's your first name?", with: "updated first"
    click_on "Edit Member →"
    expect(page).to have_text "updated first"
    expect(page).to have_text "Tell us about your secondary member"
  end

  scenario "I can edit and delete secondary members" do
    create_application
    add_primary_member
    add_secondary_member
    expect(page).to have_text "Delete"
    expect(page).to have_text "Edit"

    within all('td').last do
      click_on "Edit"
    end
    expect(page).to have_field("What's your secondary member's first name?", with: "first1")
    expect(page).to have_field("What's your secondary member's last name?",  with: "last1")

    fill_in "What's your secondary member's first name?", with: "first1 updated secondary"
    fill_in "What's your secondary member's last name?", with: "last1 updated secondary"

    click_on "Edit Member →"

    expect(page).to have_text "first1 updated secondary"

    click_on "Delete"

    expect(page).not_to have_text "first1 updated secondary"

  end

  scenario "I can edit and delete benefits apps" do
    create_application
    add_primary_member(submit=true)
    expect(page).to have_text("Submitted Applications")
    click_on "Edit"
    fill_in "What's your address?", with: "p sherman 42 wallaby way sydney"
    click_on "Continue →"
    expect(page).to have_text("Tell us about your secondary member")
    click_on "Continue →"
    click_on "Edit"
    expect(page).to have_field("What's your address?", with: "p sherman 42 wallaby way sydney")
    click_on "Continue →"
    click_on "Continue →"

    click_on "Delete"
    expect(page).not_to have_text("first")


  end


  end