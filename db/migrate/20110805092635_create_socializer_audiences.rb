class CreateSocializerAudiences < ActiveRecord::Migration
  def change
    create_table :socializer_audiences, :id => false do |t|
      t.integer  :activity_id
      t.integer  :object_id
      t.integer  :privacy_level

      t.timestamps
    end

    add_index :socializer_audiences, [ :activity_id, :object_id ], :unique => true
    add_index :socializer_audiences, :privacy_level
  end
end
