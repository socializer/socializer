# frozen_string_literal: true

class CreateSocializerActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :socializer_activities do |t|
      t.integer :actor_id, null: false
      t.integer :activity_object_id, null: false
      t.references :verb, null: false
      t.integer :target_id

      t.timestamps
    end

    add_index :socializer_activities, :actor_id
    add_index :socializer_activities, :activity_object_id
    add_index :socializer_activities, :target_id

    add_foreign_key :socializer_activities, :socializer_verbs,
                    column: :verb_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
