# frozen_string_literal: true

class CreateSocializerPersonPhones < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_person_phones do |t|
      t.integer  :person_id, null: false, foreign_key: true
      t.integer  :category,  null: false
      # TODO: What's label for
      t.integer  :label,     null: false
      t.string   :number,    null: false

      t.timestamps
    end

    add_index :socializer_person_phones, :person_id
    add_foreign_key :socializer_person_phones, :socializer_people
  end
end
