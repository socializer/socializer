class CreateSocializerAuthentications < ActiveRecord::Migration
  def change
    create_table :socializer_authentications do |t|
      t.integer  :person_id
      t.string   :provider
      t.string   :uid
      t.string   :image_url

      t.timestamps
    end
  end
end
