# frozen_string_literal: true

class CreateSocializerPersonContributions < ActiveRecord::Migration[7.1]
  def change
    create_table :socializer_person_contributions do |t|
      t.references :person, null: false
      t.string   :display_name, null: false
      t.integer  :label, null: false
      t.string   :url, null: false
      t.boolean  :current, default: false, null: false

      t.timestamps
    end

    add_foreign_key :socializer_person_contributions, :socializer_people,
                    column: :person_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
