class CreateSocializerTies < ActiveRecord::Migration
  def change
    create_table :socializer_ties do |t|
      t.integer  :contact_id, null: false
      t.integer  :circle_id, null: false

      t.timestamps null: false
    end

    add_index :socializer_ties, :contact_id
    add_index :socializer_ties, :circle_id
  end
end
