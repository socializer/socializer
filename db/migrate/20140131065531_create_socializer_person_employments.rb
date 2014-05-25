class CreateSocializerPersonEmployments < ActiveRecord::Migration
  def change
    create_table :socializer_person_employments do |t|
      t.integer  :person_id, null: false
      # TODO: change employer_name to name
      t.string   :employer_name
      # TODO: change job_title to title
      t.string   :job_title
      # TODO: change start to started_on - more inline with Rails conventions
      t.date     :start
      # TODO: change end to ended_on - more inline with Rails conventions
      t.date     :end
      t.boolean  :current
      # TODO: change job_description to description
      t.text     :job_description

      t.timestamps
    end
  end
end
