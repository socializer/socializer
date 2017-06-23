# frozen_string_literal: true

class CreateSocializerPersonAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_person_addresses do |t|
      t.integer  :person_id, null: false, foreign_key: true
      t.integer  :category, null: false
      # TODO: What's label for
      t.integer  :label
      t.string   :line1, null: false
      t.string   :line2
      t.string   :city, null: false
      t.string   :postal_code_or_zip, null: false
      t.string   :province_or_state, null: false
      t.string   :country, null: false

      t.timestamps
    end

    add_index :socializer_person_addresses, :person_id
    add_foreign_key :socializer_person_addresses, :socializer_people
  end
end
