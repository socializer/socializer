# frozen_string_literal: true

class CreateSocializerActivityFields < ActiveRecord::Migration[7.2]
  def change
    create_table :socializer_activity_fields do |t|
      t.text :content, null: false
      t.references :activity, null: false

      t.timestamps
    end

    add_foreign_key :socializer_activity_fields, :socializer_activities,
                    column: :activity_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
