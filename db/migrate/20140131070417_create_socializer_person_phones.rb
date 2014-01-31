class CreateSocializerPersonPhones < ActiveRecord::Migration
  def change
    create_table :socializer_person_phones do |t|
      t.integer  :person_id, null: false
      t.integer  :category
      t.integer  :label
      t.string   :number

      t.timestamps
    end
  end
end
