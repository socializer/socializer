# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110905175825) do

  create_table "socializer_activities", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "actor_id"
    t.integer  "object_id"
    t.integer  "target_id"
    t.string   "verb"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_activities", ["actor_id"], :name => "index_socializer_activities_on_actor_id"
  add_index "socializer_activities", ["object_id"], :name => "index_socializer_activities_on_object_id"
  add_index "socializer_activities", ["parent_id"], :name => "index_socializer_activities_on_parent_id"
  add_index "socializer_activities", ["target_id"], :name => "index_socializer_activities_on_target_id"

  create_table "socializer_audiences", :id => false, :force => true do |t|
    t.integer  "activity_id"
    t.integer  "object_id"
    t.string   "scope"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_audiences", ["activity_id", "object_id"], :name => "index_socializer_audiences_on_activity_id_and_object_id", :unique => true

  create_table "socializer_authentications", :force => true do |t|
    t.integer  "person_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "socializer_circles", :force => true do |t|
    t.integer  "author_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_circles", ["author_id"], :name => "index_socializer_circles_on_author_id"

  create_table "socializer_comments", :force => true do |t|
    t.integer  "author_id"
    t.integer  "object_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_comments", ["author_id"], :name => "index_socializer_comments_on_author_id"
  add_index "socializer_comments", ["object_id"], :name => "index_socializer_comments_on_object_id"

  create_table "socializer_embedded_objects", :force => true do |t|
    t.integer  "embeddable_id"
    t.string   "embeddable_type"
    t.integer  "like_count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_embedded_objects", ["embeddable_id"], :name => "index_socializer_embedded_objects_on_embeddable_id"

  create_table "socializer_groups", :force => true do |t|
    t.integer  "author_id"
    t.string   "name"
    t.string   "privacy_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_groups", ["author_id"], :name => "index_socializer_groups_on_author_id"

  create_table "socializer_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "member_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_memberships", ["group_id"], :name => "index_socializer_memberships_on_group_id"
  add_index "socializer_memberships", ["member_id"], :name => "index_socializer_memberships_on_member_id"

  create_table "socializer_notes", :force => true do |t|
    t.integer  "author_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_notes", ["author_id"], :name => "index_socializer_notes_on_author_id"

  create_table "socializer_people", :force => true do |t|
    t.string   "display_name"
    t.string   "email"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "socializer_ties", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "circle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_ties", ["circle_id"], :name => "index_socializer_ties_on_circle_id"
  add_index "socializer_ties", ["contact_id"], :name => "index_socializer_ties_on_contact_id"

end
