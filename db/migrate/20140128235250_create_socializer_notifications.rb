class CreateSocializerNotifications < ActiveRecord::Migration
  def change
    create_table :socializer_notifications do |t|
      t.integer :activity_id
      t.integer :person_id
      t.boolean :displayed,     :default => false
      t.boolean :read,          :default => false

      t.timestamps
    end
  end
end
