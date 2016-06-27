# frozen_string_literal: true

class CreateSocializerPersonEducations < ActiveRecord::Migration
  def change
    create_table :socializer_person_educations do |t|
      t.integer  :person_id, null: false
      # TODO: change school_name to name
      t.string   :school_name, null: false
      t.string   :major_or_field_of_study
      t.date     :started_on, null: false
      t.date     :ended_on
      t.boolean  :current, default: false
      # TODO: change courses_description to description
      t.text     :courses_description

      t.timestamps null: false
    end

    add_index :socializer_person_educations, :person_id
  end
end
