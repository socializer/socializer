# frozen_string_literal: true

class CreateSocializerPersonLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_person_links do |t|
      t.integer  :person_id, null: false, foreign_key: true
      t.string   :display_name, null: false
      t.string   :url, null: false

      t.timestamps
    end

    add_index :socializer_person_links, :person_id
    add_foreign_key :socializer_person_links, :socializer_people
  end
end
