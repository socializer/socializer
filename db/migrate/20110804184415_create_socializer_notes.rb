class CreateSocializerNotes < ActiveRecord::Migration
  def change
    create_table :socializer_notes do |t|
      t.integer  :author_id, null: false
      t.text     :content, null: false

      t.timestamps null: false
    end

    add_index :socializer_notes, :author_id
  end
end
