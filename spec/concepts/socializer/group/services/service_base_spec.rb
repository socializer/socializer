# frozen_string_literal: true

require "rails_helper"

module Socializer
  class Group
    module Services
      RSpec.describe ServiceBase, type: :service do
        let(:group) { build(:group) }
        let(:person) { build(:person) }

        describe "when the group and person arguments are nil" do
          context ".new should raise an ArgumentError" do
            let(:service) { ServiceBase.new(group: nil, person: nil) }

            it { expect { service }.to raise_error(ArgumentError) }
          end
        end

        describe "when the group argument is nil" do
          context ".new should raise an ArgumentError" do
            let(:service) { ServiceBase.new(group: nil, person: person) }

            it { expect { service }.to raise_error(ArgumentError) }
          end
        end

        describe "when the person argument is nil" do
          context ".new should raise an ArgumentError" do
            let(:service) { ServiceBase.new(group: group, person: nil) }

            it { expect { service }.to raise_error(ArgumentError) }
          end
        end

        describe ".call" do
          let(:service) do
            ServiceBase.new(group: group, person: person).call
          end

          it { expect { service }.to raise_error(NotImplementedError) }
        end
      end
    end
  end
end
