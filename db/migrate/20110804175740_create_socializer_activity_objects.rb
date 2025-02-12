# frozen_string_literal: true

class CreateSocializerActivityObjects < ActiveRecord::Migration[8.0]
  def change
    create_table :socializer_activity_objects do |t|
      t.bigint   :activitable_id,             null: false
      t.string   :activitable_type,           null: false
      t.integer  :like_count,                 default: 0
      t.integer  :unread_notifications_count, default: 0

      t.timestamps
    end

    add_index :socializer_activity_objects,
              %i[activitable_type activitable_id],
              name: "index_activity_objects_on_activitable"
  end
end
