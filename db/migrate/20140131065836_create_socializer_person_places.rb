class CreateSocializerPersonPlaces < ActiveRecord::Migration
  def change
    create_table :socializer_person_places do |t|
      t.integer  :person_id, null: false
      t.string   :city_name
      t.boolean  :current, default: false

      t.timestamps null: false
    end
  end
end
