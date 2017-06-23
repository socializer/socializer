# frozen_string_literal: true

class CreateSocializerPersonContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_person_contributions do |t|
      t.integer  :person_id, null: false, foreign_key: true
      t.string   :display_name, null: false
      t.integer  :label, null: false
      t.string   :url, null: false
      t.boolean  :current, default: false

      t.timestamps
    end

    add_index :socializer_person_contributions, :person_id
    add_foreign_key :socializer_person_contributions, :socializer_people
  end
end
