class AddIsPrimaryToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :is_primary, :boolean, default: false
  end
end
