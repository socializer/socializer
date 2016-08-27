# frozen_string_literal: true

class CreateSocializerPersonContributions < ActiveRecord::Migration[4.2]
  def change
    create_table :socializer_person_contributions do |t|
      t.string   :display_name, null: false
      t.integer  :person_id, null: false
      t.integer  :label, null: false
      t.string   :url, null: false
      t.boolean  :current, default: false

      t.timestamps null: false
    end

    add_index :socializer_person_contributions, :person_id
    add_foreign_key :socializer_person_contributions, :socializer_people
  end
end
