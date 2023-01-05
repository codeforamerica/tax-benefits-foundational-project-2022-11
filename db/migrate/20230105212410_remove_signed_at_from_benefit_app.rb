class RemoveSignedAtFromBenefitApp < ActiveRecord::Migration[7.0]
  def change
    remove_column :benefit_apps, :signed_date, :date
  end
end
