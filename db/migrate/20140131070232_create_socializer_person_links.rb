class CreateSocializerPersonLinks < ActiveRecord::Migration
  def change
    create_table :socializer_person_links do |t|
      t.string   :display_name, null: false
      t.string   :url, null: false
      t.integer  :person_id, null: false

      t.timestamps null: false
    end
  end
end
