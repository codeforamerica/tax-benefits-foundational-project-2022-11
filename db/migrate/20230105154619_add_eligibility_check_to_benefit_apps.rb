class AddEligibilityCheckToBenefitApps < ActiveRecord::Migration[7.0]
  def change
    add_column :benefit_apps, :eligible, :boolean
  end
end
