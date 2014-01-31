class CreateSocializerPersonAddresses < ActiveRecord::Migration
  def change
    create_table :socializer_person_addresses do |t|
      t.integer  :person_id, null: false
      t.integer  :category
      t.integer  :label
      t.string   :line1
      t.string   :line2
      t.string   :city
      t.string   :postal_code_or_zip
      t.string   :province_or_state
      t.string   :country

      t.timestamps
    end
  end
end
