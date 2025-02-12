# frozen_string_literal: true

class CreateSocializerPersonLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :socializer_person_links do |t|
      t.references :person, null: false
      t.string   :display_name, null: false
      t.string   :url, null: false

      t.timestamps
    end

    add_foreign_key :socializer_person_links, :socializer_people,
                    column: :person_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
