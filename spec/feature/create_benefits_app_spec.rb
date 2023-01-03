RSpec.describe "a user creating a new benefits application" do

  context "as an admin user" do

    # scenario "I can go through the flow of creating an application" do
    #   visit root_path
    #   click_on "New Application"
    #   # within ".client-profile" do
    #   #   click_on "Edit 13614-C"
    #   # end
    #
    #   expect(page).to have_text "How can we contact you?"
      # within "#primary-info" do
      #   fill_in 'First Name', with: 'Emily'
      # end
      # within "#dependents-fields" do
      #   expect(find_field("hub_update13614c_form_page1[dependents_attributes][0][first_name]").value).to eq "Lara"
      #
      #   fill_in "hub_update13614c_form_page1_dependents_attributes_0_first_name", with: "Laura"
      #   fill_in "hub_update13614c_form_page1_dependents_attributes_0_last_name", with: "Peaches"
      #   fill_in "hub_update13614c_form_page1_dependents_attributes_0_birth_date_month", with: "12"
      #   fill_in "hub_update13614c_form_page1_dependents_attributes_0_birth_date_day", with: "1"
      #   fill_in "hub_update13614c_form_page1_dependents_attributes_0_birth_date_year", with: "2008"
      #   select "9", from: "hub_update13614c_form_page1_dependents_attributes_0_months_in_home"
      #   select "Y", from: "hub_update13614c_form_page1_dependents_attributes_0_north_american_resident"
      # end
      # click_on 'Save'
      #
      # # Stay on current page upon save
      # within(".flash--notice") do
      #   expect(page).to have_text "Changes saved"
      # end
      #
      # expect(page).to have_text "Part I – Your Personal Information"
      # expect(page).to have_field('First Name', with: 'Emily')
      # expect(page).to have_text('Last client 13614-C update: Mar 4 5:10 AM')
      # within "#dependents-fields" do
      #   expect(find_field("hub_update13614c_form_page1[dependents_attributes][0][first_name]").value).to eq "Laura"
      # end
    # end
  end
  end