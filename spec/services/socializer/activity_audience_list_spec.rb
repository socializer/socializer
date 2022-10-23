# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe ActivityAudienceList, type: :service do
    let(:audience_list) do
      described_class.new(activity:).call
    end

    describe "when the activity argument is nil" do
      describe ".new should raise an ArgumentError" do
        let(:audience_list) { described_class.new(activity: nil) }

        specify { expect { audience_list }.to raise_error(ArgumentError) }
      end

      describe ".call should raise an ArgumentError" do
        let(:audience_list) { described_class.call(activity: nil) }

        specify { expect { audience_list }.to raise_error(ArgumentError) }
      end
    end

    describe "when the activity argument is the wrong type" do
      let(:audience_list) { described_class.new(activity: Person.new) }

      specify { expect { audience_list }.to raise_error(ArgumentError) }
    end

    describe ".call" do
      context "when no audience" do
        let(:activity) { create(:activity) }

        specify { expect(audience_list).to be_a(Array) }
        specify { expect(audience_list.size).to eq(1) }
        specify { expect(audience_list.first).to start_with("name") }
      end

      context "with an audience" do
        let(:person) { create(:person) }

        let(:note_attributes) do
          { content: "Test note",
            object_ids: ["public"],
            activity_verb: "post" }
        end

        let(:note) { person.activity_object.notes.create!(note_attributes) }

        let(:activity) do
          Activity.find_by(activity_object_id: note.activity_object.id)
        end

        context "when public" do
          specify { expect(audience_list.size).to eq(1) }

          specify do
            tooltip_public = I18n.t("socializer.activities.audiences." \
                                    "index.tooltip.public")

            expect(audience_list.first).to eq(tooltip_public)
          end
        end

        context "when it is circles" do
          before do
            AddDefaultCircles.call(person:)
          end

          let(:note_attributes) do
            { content: "Test note",
              object_ids: ["circles"],
              activity_verb: "post" }
          end

          specify { expect(audience_list.size).to eq(1) }
          specify { expect(audience_list.first).to start_with("name") }
        end

        context "when it is limited" do
          before do
            AddDefaultCircles.call(person:)
          end

          let(:note_attributes) do
            family = Circle.find_by(author_id: person.id,
                                    display_name: "Family")

            { content: "Test note",
              object_ids: [family.id],
              activity_verb: "post" }
          end

          specify { expect(audience_list.size).to eq(1) }
          specify { expect(audience_list.first).to start_with("name") }
        end
      end
    end
  end
end
