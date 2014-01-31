class CreateSocializerActivityObjects < ActiveRecord::Migration
  def change
    create_table :socializer_activity_objects do |t|
      t.integer  :activitable_id
      t.string   :activitable_type
      t.integer  :like_count,                 default: 0
      t.integer  :unread_notifications_count, default: 0

      t.timestamps
    end

    add_index :socializer_activity_objects, [:activitable_type, :activitable_id], name: 'index_socializer_activity_objects_on_activitable'
  end
end
