class CreateSocializerNotes < ActiveRecord::Migration
  def change
    create_table :socializer_notes do |t|
      t.integer  :author_id
      t.text     :content

      t.timestamps
    end
    
    add_index :socializer_notes, :author_id
  end
end
