class AddColumnsToBenefitApp < ActiveRecord::Migration[7.0]
  def change
    add_column :benefit_apps, :has_job, :boolean, default: false
    add_column :benefit_apps, :monthly_income, :integer, default: 0
  end
end
