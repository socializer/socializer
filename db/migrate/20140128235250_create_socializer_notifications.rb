# frozen_string_literal: true

class CreateSocializerNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :socializer_notifications do |t|
      t.references :activity, null: false
      t.references :activity_object, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end

    add_foreign_key :socializer_notifications, :socializer_activities,
                    column: :activity_id,
                    primary_key: "id",
                    on_delete: :cascade

    add_foreign_key :socializer_notifications, :socializer_activity_objects,
                    column: :activity_object_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
