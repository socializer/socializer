class CreateSocializerNotifications < ActiveRecord::Migration
  def change
    create_table :socializer_notifications do |t|
      t.integer :activity_id
      t.integer :person_id
      t.boolean :displayed
      t.boolean :read

      t.timestamps
    end
  end
end
