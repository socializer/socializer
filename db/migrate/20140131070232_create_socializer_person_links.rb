class CreateSocializerPersonLinks < ActiveRecord::Migration
  def change
    create_table :socializer_person_links do |t|
      t.integer  :person_id, null: false
      t.string   :label
      t.string   :url

      t.timestamps
    end
  end
end
