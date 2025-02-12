# frozen_string_literal: true

class CreateSocializerNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :socializer_notes do |t|
      t.bigint :author_id, null: false
      t.text :content, null: false

      t.timestamps
    end

    add_index :socializer_notes, :author_id
  end
end
