# frozen_string_literal: true

class CreateSocializerAudiences < ActiveRecord::Migration[5.1]
  def change
    create_table :socializer_audiences do |t|
      t.integer  :activity_id, null: false, foreign_key: true
      t.integer  :activity_object_id, foreign_key: true
      t.string   :privacy, null: false

      t.timestamps
    end

    add_index :socializer_audiences,
              %i[activity_id activity_object_id],
              unique: true,
              name: "index_audiences_on_activity_id__activity_object_id"

    add_index :socializer_audiences, :privacy
  end
end
