class CreateSocializerCircles < ActiveRecord::Migration
  def change
    create_table :socializer_circles do |t|
      t.integer  :author_id, null: false
      t.string   :name,      null: false
      t.text     :content

      t.timestamps
    end

    add_index :socializer_circles, :author_id
    add_index :socializer_circles, [:name, :author_id], unique: true
  end
end
