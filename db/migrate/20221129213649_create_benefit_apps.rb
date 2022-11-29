class CreateBenefitApps < ActiveRecord::Migration[7.0]
  def change
    create_table :benefit_apps do |t|
      t.string :address
      t.string :phone_number, limit: 10
      t.string :email_address

      t.timestamps
    end
  end
end
