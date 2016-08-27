# frozen_string_literal: true

class CreateSocializerMemberships < ActiveRecord::Migration[4.2]
  def change
    create_table :socializer_memberships do |t|
      t.integer  :group_id
      t.integer  :member_id
      t.boolean  :active

      t.timestamps null: false
    end

    add_index :socializer_memberships, :group_id
    add_index :socializer_memberships, :member_id
  end
end
