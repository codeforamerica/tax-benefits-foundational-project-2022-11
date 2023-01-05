class AddSignatureColumnsToBenefitApp < ActiveRecord::Migration[7.0]
  def change
    add_column :benefit_apps, :signature, :text
    add_column :benefit_apps, :signed_date, :date
  end
end
