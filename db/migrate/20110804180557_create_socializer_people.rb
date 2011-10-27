class CreateSocializerPeople < ActiveRecord::Migration
  def change
    create_table :socializer_people do |t|
      t.string   :display_name
      t.string   :email
      t.string   :language

      t.timestamps
    end
  end
end
