# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe ActivityObjectDecorator do
    let(:activity_object) { create(:activity_object) }

    let(:decorated_activity_object) do
      described_class.new(activity_object)
    end

    describe "demodulized_type" do
      specify do
        expect(decorated_activity_object.demodulized_type).to eq("Note")
      end

      specify do
        expect(decorated_activity_object.demodulized_type)
          .not_to include("Socializer::")
      end
    end

    describe "link_to_like_or_unlike" do
      context "when no current_user it returns nil" do
        before do
          without_partial_double_verification do
            allow(helper).to receive(:current_user).and_return(nil)
          end
        end

        specify do
          expect(decorated_activity_object.link_to_like_or_unlike).to be_nil
        end
      end

      context "with current_user" do
        before do
          person = create(:person)
          without_partial_double_verification do
            allow(helper).to receive(:current_user).and_return(person)
          end
        end

        let(:person) { Person.first }
        let(:result) { decorated_activity_object.link_to_like_or_unlike }

        context "when does not like" do
          specify do
            url = like_activity_path(activity_object)
            expect(result).to have_link("", href: url)
          end

          specify do
            like = t("socializer.shared.like")
            selector = "a.btn.btn-default[data-method='post'][title=#{like}]"

            expect(result).to have_selector(selector)
          end
        end

        context "when does like" do
          before do
            Activity::Services::Like.new(actor: person)
                                    .call(activity_object:)
          end

          specify do
            url = unlike_activity_path(activity_object)
            expect(result).to have_link("", href: url)
          end

          specify do
            unlike = t("socializer.shared.unlike")
            selector = "a.btn.btn-danger[data-method='delete'][title=#{unlike}]"

            expect(result).to have_selector(selector)
          end
        end
      end
    end
  end
end
