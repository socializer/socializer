# frozen_string_literal: true

class CreateSocializerIdentities < ActiveRecord::Migration[7.2]
  def change
    create_table :socializer_identities do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :socializer_identities, :email, unique: true
  end
end
