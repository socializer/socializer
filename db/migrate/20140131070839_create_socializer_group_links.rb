# frozen_string_literal: true

class CreateSocializerGroupLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_group_links do |t|
      t.integer  :group_id, null: false, foreign_key: true
      t.string   :display_name, null: false
      t.string   :url, null: false

      t.timestamps
    end

    add_index :socializer_group_links, :group_id
    add_foreign_key :socializer_group_links, :socializer_groups
  end
end
