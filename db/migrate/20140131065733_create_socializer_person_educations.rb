# frozen_string_literal: true

class CreateSocializerPersonEducations < ActiveRecord::Migration[7.1]
  def change
    create_table :socializer_person_educations do |t|
      t.references :person, null: false
      # TODO: change school_name to name
      t.string   :school_name, null: false
      t.string   :major_or_field_of_study
      t.date     :started_on, null: false
      t.date     :ended_on
      t.boolean  :current, default: false, null: false
      # TODO: change courses_description to description
      t.text     :courses_description

      t.timestamps
    end

    add_foreign_key :socializer_person_educations, :socializer_people,
                    column: :person_id,
                    primary_key: "id",
                    on_delete: :cascade
  end
end
