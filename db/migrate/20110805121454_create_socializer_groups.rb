class CreateSocializerGroups < ActiveRecord::Migration
  def change
    create_table :socializer_groups do |t|
      t.integer  :author_id
      t.string   :name
      t.integer  :privacy_level

      t.timestamps
    end

    add_index :socializer_groups, :author_id
    add_index :socializer_groups, [:name, :author_id], unique: true
  end
end
