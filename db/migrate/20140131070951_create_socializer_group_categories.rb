class CreateSocializerGroupCategories < ActiveRecord::Migration
  def change
    create_table :socializer_group_categories do |t|
      t.integer  :group_id,     null: false
      t.string   :display_name

      t.timestamps
    end
  end
end
