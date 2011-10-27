class CreateSocializerEmbeddedObjects < ActiveRecord::Migration
  def change
    create_table :socializer_embedded_objects do |t|
      t.integer  :embeddable_id
      t.string   :embeddable_type
      t.integer  :like_count,          :default => 0

      t.timestamps
    end
    
    add_index :socializer_embedded_objects, :embeddable_id
  end
end
