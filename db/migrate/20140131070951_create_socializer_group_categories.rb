# frozen_string_literal: true

class CreateSocializerGroupCategories < ActiveRecord::Migration
  def change
    create_table :socializer_group_categories do |t|
      t.integer :group_id,     null: false
      t.string  :display_name, null: false

      t.timestamps null: false
    end

    add_index :socializer_group_categories, :group_id
    add_foreign_key :socializer_group_categories, :socializer_groups
  end
end
