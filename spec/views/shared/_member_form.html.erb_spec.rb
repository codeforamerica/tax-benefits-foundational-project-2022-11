require 'rails_helper'

RSpec.describe "member_form", type: :view do
  context "for secondary members" do
    it "informs the user to input info for them" do
      assign(:member_form, build(:secondary_member))
      render("shared/member_form", form_title: "Testing", button_title: "Title")
      expect(rendered).to include("secondary member")
    end
  end

  context "for primary members" do
    it "informs the user to input info for themselves" do
      assign(:member_form, build(:primary_member))
      render("shared/member_form", form_title: "Testing", button_title: "Title")

      expect(rendered).not_to include("secondary member")
      expect(rendered).to include("your first name")
    end
  end
end
