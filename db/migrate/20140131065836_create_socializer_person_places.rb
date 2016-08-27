# frozen_string_literal: true

class CreateSocializerPersonPlaces < ActiveRecord::Migration[4.2]
  def change
    create_table :socializer_person_places do |t|
      t.integer  :person_id, null: false
      t.string   :city_name
      t.boolean  :current, default: false

      t.timestamps null: false
    end

    add_index :socializer_person_places, :person_id
    add_foreign_key :socializer_person_places, :socializer_people
  end
end
