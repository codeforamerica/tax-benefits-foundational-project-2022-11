class AddSubmittedAtToBenefitApps < ActiveRecord::Migration[7.0]
  def change
    add_column :benefit_apps, :submitted_at, :date
  end
end
