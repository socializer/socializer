# frozen_string_literal: true

class CreateSocializerCircles < ActiveRecord::Migration[7.2]
  def change
    create_table :socializer_circles do |t|
      t.bigint :author_id, index: true, null: false
      t.string :display_name, null: false
      t.text :content

      t.timestamps
    end

    add_index :socializer_circles,
              "lower(display_name), author_id",
              unique: true
  end
end
