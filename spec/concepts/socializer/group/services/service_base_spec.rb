# frozen_string_literal: true

require "rails_helper"

module Socializer
  class Group
    module Services
      RSpec.describe ServiceBase, type: :service do
        let(:group) { build(:group) }
        let(:person) { build(:person) }

        context "when the group and person arguments are nil" do
          describe ".new should raise an ArgumentError" do
            let(:service) { ServiceBase.new(group: nil, person: nil) }

            it do
              expect { service }.to raise_error(Dry::Types::ConstraintError)
            end
          end
        end

        context "when the group argument is nil" do
          describe ".new should raise an ArgumentError" do
            let(:service) { ServiceBase.new(group: nil, person: person) }

            it do
              expect { service }.to raise_error(Dry::Types::ConstraintError)
            end
          end
        end

        context "when the person argument is nil" do
          describe ".new should raise an ArgumentError" do
            let(:service) { ServiceBase.new(group: group, person: nil) }

            it do
              expect { service }.to raise_error(Dry::Types::ConstraintError)
            end
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
