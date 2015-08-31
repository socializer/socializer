class CreateSocializerGroupLinks < ActiveRecord::Migration
  def change
    create_table :socializer_group_links do |t|
      t.integer  :group_id, null: false
      t.string   :display_name
      t.string   :url

      t.timestamps null: false
    end
  end
end
