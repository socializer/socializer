# frozen_string_literal: true

class CreateSocializerActivityFields < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_activity_fields do |t|
      t.text :content, null: false
      t.references :activity, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
