require 'rails_helper'

RSpec.describe "member list", type: :view do
  let(:benefit_app) { create(:benefit_app_with_primary_member, secondary_members: build_list(:secondary_member, 3))}
  let(:members) { benefit_app.secondary_members.to_a + [benefit_app.primary_member] }

  before do
    assign(:members, members)
    render partial: "benefits_applications/member_list"
  end

  context "for primary members" do
    it "does not show a link to delete" do
      expect(rendered).not_to include(delete_member_path(member_id: benefit_app.primary_member.id))
   end
  end

  context "for secondary members" do
    it "shows a link to delete" do
      secondary_member = benefit_app.secondary_members.last
      expect(rendered).to include(delete_member_path(member_id: secondary_member.id))
    end
  end
end
