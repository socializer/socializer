class CreateSocializerActivities < ActiveRecord::Migration
  def change
    create_table :socializer_activities do |t|
      t.integer  :actor_id
      t.integer  :activity_object_id
      t.integer  :target_id
      t.integer  :verb_id
      t.text     :content

      t.timestamps
    end

    add_index :socializer_activities, :actor_id
    add_index :socializer_activities, :activity_object_id
    add_index :socializer_activities, :target_id
    add_index :socializer_activities, :verb_id
  end
end
