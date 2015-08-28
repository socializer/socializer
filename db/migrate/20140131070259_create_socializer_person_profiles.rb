class CreateSocializerPersonProfiles < ActiveRecord::Migration
  def change
    create_table :socializer_person_profiles do |t|
      t.integer  :person_id, null: false
      t.string   :display_name, null: false
      t.string   :url, null: false

      t.timestamps null: false
    end
  end
end
