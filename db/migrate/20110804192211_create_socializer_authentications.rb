class CreateSocializerAuthentications < ActiveRecord::Migration
  def change
    create_table :socializer_authentications do |t|
      t.integer  :person_id, null: false
      t.string   :provider,  null: false
      t.string   :uid,       null: false
      t.string   :image_url

      t.timestamps null: false
    end

    add_index :socializer_authentications, :person_id
    add_index :socializer_authentications, :provider
  end
end
