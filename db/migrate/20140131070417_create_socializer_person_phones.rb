class CreateSocializerPersonPhones < ActiveRecord::Migration
  def change
    create_table :socializer_person_phones do |t|
      t.integer  :person_id, null: false
      # TODO: add null: false
      t.integer  :category
      # TODO: change label to name
      # TODO: add null: false
      t.integer  :label
      # TODO: add null: false
      t.string   :number

      t.timestamps
    end
  end
end
