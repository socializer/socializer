# frozen_string_literal: true

class CreateSocializerGroupCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :socializer_group_categories do |t|
      t.references :group, null: false
      t.string :display_name, null: false

      t.timestamps
    end

    add_foreign_key :socializer_group_categories, :socializer_groups,
                    column: :group_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
