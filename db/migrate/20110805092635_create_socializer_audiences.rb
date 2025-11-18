# frozen_string_literal: true

class CreateSocializerAudiences < ActiveRecord::Migration[8.1]
  def change
    create_table :socializer_audiences do |t|
      t.references :activity, null: false
      t.references :activity_object
      t.string :privacy, index: true, null: false

      t.timestamps
    end

    add_index :socializer_audiences,
              %i[activity_id activity_object_id],
              unique: true,
              name: "index_audiences_on_activity_id__activity_object_id"

    add_foreign_key :socializer_audiences, :socializer_activities,
                    column: :activity_id,
                    primary_key: "id",
                    on_delete: :cascade

    add_foreign_key :socializer_audiences, :socializer_activity_objects,
                    column: :activity_object_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
