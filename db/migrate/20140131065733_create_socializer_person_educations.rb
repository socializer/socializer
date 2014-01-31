class CreateSocializerPersonEducations < ActiveRecord::Migration
  def change
    create_table :socializer_person_educations do |t|
      t.integer  :person_id, null: false
      t.string   :school_name
      t.string   :major_or_field_of_study
      t.date     :start
      t.date     :end
      t.boolean  :current
      t.text     :courses_description

      t.timestamps
    end
  end
end
