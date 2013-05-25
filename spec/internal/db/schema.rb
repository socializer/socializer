ActiveRecord::Schema.define do

  create_table "socializer_activities", force: true do |t|
    t.integer  "actor_id"
    t.integer  "object_id"
    t.integer  "target_id"
    t.integer  "verb_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_activities", ["actor_id"], name: "index_socializer_activities_on_actor_id"
  add_index "socializer_activities", ["object_id"], name: "index_socializer_activities_on_object_id"
  add_index "socializer_activities", ["target_id"], name: "index_socializer_activities_on_target_id"
  add_index "socializer_activities", ["verb_id"], name: "index_socializer_activities_on_verb_id"

  create_table "socializer_activity_objects", force: true do |t|
    t.integer  "activitable_id"
    t.string   "activitable_type"
    t.integer  "like_count",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_activity_objects", ["activitable_type", "activitable_id"], name: "index_socializer_activity_objects_on_activitable"

  create_table "socializer_audiences", id: false, force: true do |t|
    t.integer  "activity_id"
    t.integer  "object_id"
    t.integer  "privacy_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_audiences", ["activity_id", "object_id"], name: "index_socializer_audiences_on_activity_id_and_object_id", unique: true
  add_index "socializer_audiences", ["privacy_level"], name: "index_socializer_audiences_on_privacy_level"

  create_table "socializer_authentications", force: true do |t|
    t.integer  "person_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "socializer_circles", force: true do |t|
    t.integer  "author_id"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_circles", ["author_id"], name: "index_socializer_circles_on_author_id"
  add_index "socializer_circles", ["name", "author_id"], name: "index_socializer_circles_on_name_and_author_id", unique: true

  create_table "socializer_comments", force: true do |t|
    t.integer  "author_id"
    t.integer  "object_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_comments", ["author_id"], name: "index_socializer_comments_on_author_id"
  add_index "socializer_comments", ["object_id"], name: "index_socializer_comments_on_object_id"

  create_table "socializer_groups", force: true do |t|
    t.integer  "author_id"
    t.string   "name"
    t.integer  "privacy_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_groups", ["author_id"], name: "index_socializer_groups_on_author_id"
  add_index "socializer_groups", ["name", "author_id"], name: "index_socializer_groups_on_name_and_author_id", unique: true
  add_index "socializer_groups", ["privacy_level"], name: "index_socializer_groups_on_privacy_level"

  create_table "socializer_identities", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "socializer_memberships", force: true do |t|
    t.integer  "group_id"
    t.integer  "member_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_memberships", ["group_id"], name: "index_socializer_memberships_on_group_id"
  add_index "socializer_memberships", ["member_id"], name: "index_socializer_memberships_on_member_id"

  create_table "socializer_notes", force: true do |t|
    t.integer  "author_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_notes", ["author_id"], name: "index_socializer_notes_on_author_id"

  create_table "socializer_people", force: true do |t|
    t.string   "display_name"
    t.string   "email"
    t.string   "language"
    t.string   "avatar_provider"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "socializer_ties", force: true do |t|
    t.integer  "contact_id"
    t.integer  "circle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_ties", ["circle_id"], name: "index_socializer_ties_on_circle_id"
  add_index "socializer_ties", ["contact_id"], name: "index_socializer_ties_on_contact_id"

  create_table "socializer_verbs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "socializer_verbs", ["name"], name: "index_socializer_verbs_on_name", unique: true

end
