class AddIndexToMembersForSecondaries < ActiveRecord::Migration[7.0]
  def change
    # Makes sure that we can quickly find all of the secondaries members of an app.
    add_index :members, [:benefit_app_id, :is_primary],
              where: "is_primary = FALSE",
              name: :multiple_assoc_of_secondary_member_to_benefit_app
  end
end
