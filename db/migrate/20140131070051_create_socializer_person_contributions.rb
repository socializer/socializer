class CreateSocializerPersonContributions < ActiveRecord::Migration
  def change
    create_table :socializer_person_contributions do |t|
      t.integer  :person_id, null: false
      t.string   :label
      t.string   :url
      t.boolean  :current

      t.timestamps null: false
    end
  end
end
