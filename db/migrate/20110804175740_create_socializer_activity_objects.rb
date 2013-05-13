class CreateSocializerActivityObjects < ActiveRecord::Migration
  def change
    create_table :socializer_activity_objects do |t|
      t.integer  :embeddable_id
      t.string   :embeddable_type
      t.integer  :like_count,          :default => 0

      t.timestamps
    end

    add_index :socializer_activity_objects, [:embeddable_type, :embeddable_id], name: 'index_socializer_activity_objects_on_embeddable'
  end
end
