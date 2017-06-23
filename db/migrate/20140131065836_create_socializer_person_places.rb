# frozen_string_literal: true

class CreateSocializerPersonPlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_person_places do |t|
      t.integer  :person_id, null: false, foreign_key: true
      t.string   :city_name
      t.boolean  :current, default: false

      t.timestamps
    end

    add_index :socializer_person_places, :person_id
    add_foreign_key :socializer_person_places, :socializer_people
  end
end
