require "rails_helper"

module Socializer
  RSpec.describe ActivityObjectDecorator, type: :decorator do
    let(:activity_object) { create(:socializer_activity_object) }

    let(:decorated_activity_object) do
      ActivityObjectDecorator.new(activity_object)
    end

    context "link_to_like_or_unlike" do
      context "to return nil when no current_user" do
        before do
          allow(helper).to receive(:current_user).and_return(nil)
        end

        it do
          expect(decorated_activity_object.link_to_like_or_unlike).to eq(nil)
        end
      end

      context "with current_user" do
        before do
          person = create(:socializer_person)
          allow(helper).to receive(:current_user).and_return(person)
        end

        let(:person) { Person.first }
        let(:result) { decorated_activity_object.link_to_like_or_unlike }

        context "does not like" do
          let(:url) { like_activity_path(activity_object) }

          let(:selector) do
            like = t("socializer.shared.like")
            "a.btn.btn-default[data-method='post'][title=#{like}]"
          end

          it { expect(result).to have_link("", href: url) }
          it { expect(result).to have_selector(selector) }
        end

        context "does like" do
          before { activity_object.like(person) }
          let(:url) { unlike_activity_path(activity_object) }

          let(:selector) do
            unlike = t("socializer.shared.unlike")
            "a.btn.btn-danger[data-method='delete'][title=#{unlike}]"
          end

          it { expect(result).to have_link("", href: url) }
          it { expect(result).to have_selector(selector) }
        end
      end
    end
  end
end
