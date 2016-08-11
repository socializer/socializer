# frozen_string_literal: true

class CreateSocializerNotifications < ActiveRecord::Migration
  def change
    create_table :socializer_notifications do |t|
      t.integer :activity_id
      t.integer :activity_object_id
      t.boolean :read, default: false

      t.timestamps null: false
    end

    add_index :socializer_notifications, :activity_id
    add_index :socializer_notifications, :activity_object_id

    add_foreign_key :socializer_notifications, :socializer_activities
    add_foreign_key :socializer_notifications, :socializer_activity_objects
  end
end
