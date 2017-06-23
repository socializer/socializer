# frozen_string_literal: true

class CreateSocializerMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_memberships do |t|
      t.integer  :group_id, foreign_key: true
      t.integer  :member_id
      t.boolean  :active

      t.timestamps
    end

    add_index :socializer_memberships, :group_id
    add_index :socializer_memberships, :member_id
  end
end
