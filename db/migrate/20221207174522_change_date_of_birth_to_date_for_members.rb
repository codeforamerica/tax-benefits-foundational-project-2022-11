class ChangeDateOfBirthToDateForMembers < ActiveRecord::Migration[7.0]
  def change
    change_column :members, :date_of_birth, :date
  end
end
