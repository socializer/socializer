class CreateSocializerActivityFields < ActiveRecord::Migration
  def change
    create_table :socializer_activity_fields do |t|
      t.text :content, null: false
      t.references :activity, index: true, null: false

      t.timestamps null: false
    end
  end
end
