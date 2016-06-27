# frozen_string_literal: true

class CreateSocializerComments < ActiveRecord::Migration
  def change
    create_table :socializer_comments do |t|
      t.integer  :author_id, null: false
      t.text     :content,   null: false

      t.timestamps null: false
    end

    add_index :socializer_comments, :author_id
  end
end
