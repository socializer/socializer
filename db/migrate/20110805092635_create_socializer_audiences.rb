class CreateSocializerAudiences < ActiveRecord::Migration
  def change
    create_table :socializer_audiences, :id => false do |t|
      t.integer  :activity_id
      t.integer  :object_id
      t.string   :scope

      t.timestamps
    end
    
    add_index :socializer_audiences, [ :activity_id, :object_id ], :unique => true
  end
end
