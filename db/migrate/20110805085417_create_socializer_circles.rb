class CreateSocializerCircles < ActiveRecord::Migration
  def change
    create_table :socializer_circles do |t|
      t.integer  :author_id
      t.string   :name
      t.text     :description
      
      t.timestamps
    end
    
    add_index :socializer_circles, :author_id
  end
end
