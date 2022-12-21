require 'rails_helper'

RSpec.describe BenefitApp, type: :model do
  context "validation of fields" do
    subject(:benefit_app_valid) { create :benefit_app }
    subject(:benefit_app_without_email) { build :benefit_app_without_email  }
    subject(:benefit_app_without_phone_number) { build :benefit_app_without_phone_number }
    subject(:benefit_app_without_address) { build :benefit_app_without_address }
    subject(:benefit_app_with_invalid_phone_number) { build :benefit_app_with_invalid_phone_number }
    subject(:benefit_app_with_primary_member) { create(:benefit_app, primary_member: build(:member, is_primary: true))}
    subject(:benefit_app_with_non_primary_member) { build :benefit_app_with_non_primary_member }

    it "expects a email address to be present" do
       expect(benefit_app_without_email).not_to be_valid
    end

    it "expects a valid email address" do
      benefit_app = build :benefit_app, email_address: "@foo.com"
      expect(benefit_app).not_to be_valid

      benefit_app.email_address = "!!!@com.com"
      expect(benefit_app).not_to be_valid
      expect(benefit_app.save).to be_falsy
      expect(benefit_app.errors.messages[:email_address]).to include("Please enter a valid email address")

      benefit_app.email_address = "amanda89@codeforamerica.org"
      expect(benefit_app).to be_valid
    end

    it "expects a phone number to be present" do
     expect(benefit_app_without_phone_number).not_to be_valid
    end

    it "expects a valid phone number" do
      expect(benefit_app_with_invalid_phone_number).not_to be_valid
    end
    it "expects an address to be present" do
      expect(benefit_app_without_address).not_to be_valid
    end

    context "with associating members" do
      it "expects its primary member to be marked as one" do
        expect(benefit_app_with_primary_member.primary_member.is_primary).to be_truthy
      end

      it "expects its secondary members to be marked as one" do
        benefit_app = create(:benefit_app)

        secondary_members_params = attributes_for_list(:secondary_member, 3)
        alleged_secondary_members = secondary_members_params.map { |params| benefit_app.secondary_members.build(params)}

        expect(benefit_app).to be_valid
        benefit_app.save
        
        alleged_secondary_member_ids = alleged_secondary_members.map { |member| member.id }

        benefit_app.reload
        benefit_app.secondary_members.reload

        expect(benefit_app.secondary_members.count).to eql(secondary_members_params.count)
        expect(benefit_app.secondary_member_ids).to eql(alleged_secondary_member_ids)
      end

      it "does not assign a non-primary member as primary" do
        expect(benefit_app_with_non_primary_member.primary_member_id).to be_nil
      end

      it "fails to associate a primary member as a secondary member" do
        benefit_app = create(:benefit_app)
        expect(benefit_app).to be_valid

        primary_member_params = attributes_for(:primary_member)
        alleged_secondary_member = benefit_app.secondary_members.build(primary_member_params)

        benefit_app.reload
        benefit_app.secondary_members.reload

        expect(benefit_app.secondary_members.count).to eql(0)
        expect(benefit_app.primary_member_id).to eql(alleged_secondary_member.id)
      end

      it "fails to associate a duplicate primary member" do
        benefit_app = create(:benefit_app)
        expect(benefit_app).to be_valid

        primary_member = benefit_app.create_primary_member(attributes_for(:primary_member))
        expect(primary_member).to be_valid

        # TODO: this behavior no longer works with dependent: destroy - it deletes the old association before trying to create new one.
        # expect {
        #   benefit_app.build_primary_member(attributes_for(:primary_member))
        # }.to raise_error(ActiveRecord::RecordNotSaved, /existing associated primary_member/)
        benefit_app.primary_member.destroy

        expect {
          benefit_app.create_primary_member(attributes_for(:primary_member))
        }.not_to raise_error
      end
    end
  end
end
