class CreateSocializerAudiences < ActiveRecord::Migration
  def change
    create_table :socializer_audiences do |t|
      t.integer  :activity_id, null: false
      t.integer  :activity_object_id
      t.integer  :privacy_level, null: false

      t.timestamps
    end

    add_index :socializer_audiences, [ :activity_id, :activity_object_id ], :unique => true, name: 'index_socializer_audiences_on_activity_id__activity_object_id'
    add_index :socializer_audiences, :privacy_level
  end
end
