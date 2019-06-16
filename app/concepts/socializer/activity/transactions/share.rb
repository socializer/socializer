# frozen_string_literal: true

require "dry-transaction"

# TODO: Would dry-monads Do notation make more sense?

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Activity related objects
  #
  class Activity
    #
    # Namespace for Contract related objects
    #
    module Transactions
      #
      # Transaction object for creating a share for Socializer::Activity
      #
      # @example
      #   transaction = Activity::Transaction::Share.new
      #   transaction.with_step_args(validate: [actor_id: current_user.guid])
      #              .call(params) dp |result|
      #     result.success do |share|
      #       puts "Created result for #{share.activity_object}!"
      #     end
      #
      #     result.failure :validate do |validation|
      #       # Runs only when the transaction fails on the :validate step
      #       puts "Please provide a valid share."
      #     end
      #
      #     result.failure do |error|
      #       # Runs for any other failure
      #       puts "Couldn't create the share."
      #     end
      #   end
      class Share
        include Dry::Transaction

        # around :transaction, with: :transaction
        step :validate
        step :create

        private

        def validate(input)
          contract = Activity::Contracts::Share.new
          result = contract.call(share_params(params: input))

          if result.success?
            Success(result)
          else
            Failure(result.errors)
          end
        end

        def create(input)
          Success(Socializer::CreateActivity.new(input.to_h).call)
        end

        def share_params(params:)
          params[:activity_object_id] = params[:activity_id]
          params[:verb] = verb

          params
        end

        def verb
          "share"
        end
      end
    end
  end
end
