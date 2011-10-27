class CreateSocializerActivities < ActiveRecord::Migration
  def change
    create_table :socializer_activities do |t|
      t.integer  :parent_id
      t.integer  :actor_id
      t.integer  :object_id
      t.integer  :target_id
      t.string   :verb
      t.text     :content

      t.timestamps
    end
    
    add_index :socializer_activities, :parent_id
    add_index :socializer_activities, :actor_id
    add_index :socializer_activities, :object_id
    add_index :socializer_activities, :target_id
  end
end
