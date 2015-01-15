class CreateSocializerPersonEducations < ActiveRecord::Migration
  def change
    create_table :socializer_person_educations do |t|
      t.integer  :person_id, null: false
      # TODO: change school_name to name
      t.string   :school_name
      t.string   :major_or_field_of_study
      t.date     :started_on
      t.date     :ended_on
      t.boolean  :current
      # TODO: change courses_description to description
      t.text     :courses_description

      t.timestamps null: false
    end
  end
end
