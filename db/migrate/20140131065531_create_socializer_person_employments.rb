class CreateSocializerPersonEmployments < ActiveRecord::Migration
  def change
    create_table :socializer_person_employments do |t|
      t.integer  :person_id, null: false
      t.string   :employer_name
      t.string   :job_title
      t.date     :start
      t.date     :end
      t.boolean  :current
      t.text     :job_description

      t.timestamps
    end
  end
end
