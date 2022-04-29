# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2014_01_31_070951) do
  create_table "socializer_activities", force: :cascade do |t|
    t.integer "actor_id", null: false
    t.integer "activity_object_id", null: false
    t.integer "verb_id", null: false
    t.integer "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_object_id"], name: "index_socializer_activities_on_activity_object_id"
    t.index ["actor_id"], name: "index_socializer_activities_on_actor_id"
    t.index ["target_id"], name: "index_socializer_activities_on_target_id"
    t.index ["verb_id"], name: "index_socializer_activities_on_verb_id"
  end

  create_table "socializer_activity_fields", force: :cascade do |t|
    t.text "content", null: false
    t.integer "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_socializer_activity_fields_on_activity_id"
  end

  create_table "socializer_activity_objects", force: :cascade do |t|
    t.integer "activitable_id", null: false
    t.string "activitable_type", null: false
    t.integer "like_count", default: 0
    t.integer "unread_notifications_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activitable_type", "activitable_id"], name: "index_activity_objects_on_activitable"
  end

  create_table "socializer_audiences", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "activity_object_id"
    t.string "privacy", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "activity_object_id"], name: "index_audiences_on_activity_id__activity_object_id", unique: true
    t.index ["activity_id"], name: "index_socializer_audiences_on_activity_id"
    t.index ["activity_object_id"], name: "index_socializer_audiences_on_activity_object_id"
    t.index ["privacy"], name: "index_socializer_audiences_on_privacy"
  end

  create_table "socializer_authentications", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_authentications_on_person_id"
    t.index ["provider"], name: "index_socializer_authentications_on_provider"
  end

  create_table "socializer_circles", force: :cascade do |t|
    t.integer "author_id", null: false
    t.string "display_name", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_socializer_circles_on_author_id"
    t.index ["display_name", "author_id"], name: "index_socializer_circles_on_display_name_and_author_id", unique: true
  end

  create_table "socializer_comments", force: :cascade do |t|
    t.integer "author_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_socializer_comments_on_author_id"
  end

  create_table "socializer_group_categories", force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "display_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_socializer_group_categories_on_group_id"
  end

  create_table "socializer_group_links", force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "display_name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_socializer_group_links_on_group_id"
  end

  create_table "socializer_groups", force: :cascade do |t|
    t.integer "author_id", null: false
    t.string "display_name", null: false
    t.integer "privacy", null: false
    t.string "tagline"
    t.text "about"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_socializer_groups_on_author_id"
    t.index ["display_name", "author_id"], name: "index_socializer_groups_on_display_name_and_author_id", unique: true
    t.index ["privacy"], name: "index_socializer_groups_on_privacy"
  end

  create_table "socializer_identities", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_socializer_identities_on_email", unique: true
  end

  create_table "socializer_memberships", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "member_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_socializer_memberships_on_group_id"
    t.index ["member_id"], name: "index_socializer_memberships_on_member_id"
  end

  create_table "socializer_notes", force: :cascade do |t|
    t.integer "author_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_socializer_notes_on_author_id"
  end

  create_table "socializer_notifications", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "activity_object_id", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_socializer_notifications_on_activity_id"
    t.index ["activity_object_id"], name: "index_socializer_notifications_on_activity_object_id"
  end

  create_table "socializer_people", force: :cascade do |t|
    t.string "display_name"
    t.string "email"
    t.string "language"
    t.string "avatar_provider"
    t.string "tagline"
    t.text "introduction"
    t.string "bragging_rights"
    t.string "occupation"
    t.string "skills"
    t.integer "gender"
    t.boolean "looking_for_friends"
    t.boolean "looking_for_dating"
    t.boolean "looking_for_relationship"
    t.boolean "looking_for_networking"
    t.date "birthdate"
    t.integer "relationship"
    t.string "other_names"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "socializer_person_addresses", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "category", null: false
    t.integer "label"
    t.string "line1", null: false
    t.string "line2"
    t.string "city", null: false
    t.string "postal_code_or_zip", null: false
    t.string "province_or_state", null: false
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_person_addresses_on_person_id"
  end

  create_table "socializer_person_contributions", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "display_name", null: false
    t.integer "label", null: false
    t.string "url", null: false
    t.boolean "current", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_person_contributions_on_person_id"
  end

  create_table "socializer_person_educations", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "school_name", null: false
    t.string "major_or_field_of_study"
    t.date "started_on", null: false
    t.date "ended_on"
    t.boolean "current", default: false
    t.text "courses_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_person_educations_on_person_id"
  end

  create_table "socializer_person_employments", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "employer_name", null: false
    t.string "job_title"
    t.date "started_on", null: false
    t.date "ended_on"
    t.boolean "current", default: false
    t.text "job_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_person_employments_on_person_id"
  end

  create_table "socializer_person_links", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "display_name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_person_links_on_person_id"
  end

  create_table "socializer_person_phones", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "category", null: false
    t.integer "label", null: false
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_person_phones_on_person_id"
  end

  create_table "socializer_person_places", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "city_name"
    t.boolean "current", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_person_places_on_person_id"
  end

  create_table "socializer_person_profiles", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "display_name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_socializer_person_profiles_on_person_id"
  end

  create_table "socializer_ties", force: :cascade do |t|
    t.integer "contact_id", null: false
    t.integer "circle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["circle_id"], name: "index_socializer_ties_on_circle_id"
    t.index ["contact_id"], name: "index_socializer_ties_on_contact_id"
  end

  create_table "socializer_verbs", force: :cascade do |t|
    t.string "display_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_name"], name: "index_socializer_verbs_on_display_name", unique: true
  end

  add_foreign_key "socializer_activities", "socializer_verbs", column: "verb_id", on_delete: :cascade
  add_foreign_key "socializer_activity_fields", "socializer_activities", column: "activity_id", on_delete: :cascade
  add_foreign_key "socializer_audiences", "socializer_activities", column: "activity_id", on_delete: :cascade
  add_foreign_key "socializer_audiences", "socializer_activity_objects", column: "activity_object_id", on_delete: :cascade
  add_foreign_key "socializer_group_categories", "socializer_groups", column: "group_id", on_delete: :cascade
  add_foreign_key "socializer_group_links", "socializer_groups", column: "group_id", on_delete: :cascade
  add_foreign_key "socializer_memberships", "socializer_groups", column: "group_id", on_delete: :cascade
  add_foreign_key "socializer_notifications", "socializer_activities", column: "activity_id", on_delete: :cascade
  add_foreign_key "socializer_notifications", "socializer_activity_objects", column: "activity_object_id", on_delete: :cascade
  add_foreign_key "socializer_person_addresses", "socializer_people", column: "person_id", on_delete: :cascade
  add_foreign_key "socializer_person_contributions", "socializer_people", column: "person_id", on_delete: :cascade
  add_foreign_key "socializer_person_educations", "socializer_people", column: "person_id", on_delete: :cascade
  add_foreign_key "socializer_person_employments", "socializer_people", column: "person_id", on_delete: :cascade
  add_foreign_key "socializer_person_links", "socializer_people", column: "person_id", on_delete: :cascade
  add_foreign_key "socializer_person_phones", "socializer_people", column: "person_id", on_delete: :cascade
  add_foreign_key "socializer_person_places", "socializer_people", column: "person_id", on_delete: :cascade
  add_foreign_key "socializer_person_profiles", "socializer_people", column: "person_id", on_delete: :cascade
  add_foreign_key "socializer_ties", "socializer_circles", column: "circle_id", on_delete: :cascade
end
