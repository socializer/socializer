class CreateSocializerCircles < ActiveRecord::Migration
  def change
    create_table :socializer_circles do |t|
      t.integer  :author_id,    null: false
      t.string   :display_name, null: false
      t.text     :content

      t.timestamps
    end

    add_index :socializer_circles, :author_id
    add_index :socializer_circles, [:display_name, :author_id], unique: true
  end
end
