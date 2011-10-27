class CreateSocializerGroups < ActiveRecord::Migration
  def change
    create_table :socializer_groups do |t|
      t.integer  :author_id
      t.string   :name
      t.string   :privacy_level

      t.timestamps
    end
    
    add_index :socializer_groups, :author_id
  end
end
