# frozen_string_literal: true

class CreateSocializerPersonEmployments < ActiveRecord::Migration[4.2]
  def change
    create_table :socializer_person_employments do |t|
      t.integer  :person_id, null: false
      # TODO: change employer_name to name
      t.string   :employer_name, null: false
      # TODO: change job_title to title
      t.string   :job_title
      t.date     :started_on, null: false
      t.date     :ended_on
      t.boolean  :current, default: false
      # TODO: change job_description to description
      t.text     :job_description

      t.timestamps null: false
    end

    add_index :socializer_person_employments, :person_id
    add_foreign_key :socializer_person_employments, :socializer_people
  end
end
