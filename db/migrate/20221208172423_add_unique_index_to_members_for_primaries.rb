class AddUniqueIndexToMembersForPrimaries < ActiveRecord::Migration[7.0]
  def change
    # This restricts a primary member to be the sole one for an application.
    add_index :members, [:benefit_app_id, :is_primary],
              unique: true,
              where: "is_primary = TRUE",
              name: :single_assoc_of_primary_member_to_benefit_app
  end
end
