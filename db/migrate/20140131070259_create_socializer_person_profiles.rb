# frozen_string_literal: true

class CreateSocializerPersonProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :socializer_person_profiles do |t|
      t.references :person, null: false
      t.string   :display_name, null: false
      t.string   :url, null: false

      t.timestamps
    end

    add_foreign_key :socializer_person_profiles, :socializer_people,
                    column: :person_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
