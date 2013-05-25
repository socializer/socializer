class CreateSocializerComments < ActiveRecord::Migration
  def change
    create_table :socializer_comments do |t|
      t.integer  :author_id
      t.integer  :activity_id
      t.text     :content

      t.timestamps
    end

    add_index :socializer_comments, :author_id
    add_index :socializer_comments, :activity_id
  end
end
