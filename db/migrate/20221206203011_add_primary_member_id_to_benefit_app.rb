class AddPrimaryMemberIdToBenefitApp < ActiveRecord::Migration[7.0]
  def change
    add_reference(:benefit_apps, :primary_member, foreign_key: { to_table: :members })
  end
end
