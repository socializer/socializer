# frozen_string_literal: true

class CreateSocializerMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_memberships do |t|
      t.references :group, null: false
      t.integer  :member_id, null: false
      t.boolean  :active

      t.timestamps
    end

    add_index :socializer_memberships, :member_id

    add_foreign_key :socializer_memberships, :socializer_groups,
                    column: :group_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
