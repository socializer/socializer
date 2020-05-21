# frozen_string_literal: true

require "dry/initializer"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Namespace for Group related objects
  #
  class Group
    #
    # Namespace for Service related objects
    #
    module Services
      #
      # Base class for Group::Service
      #
      class ServiceBase
        # Initializer
        #
        extend Dry::Initializer

        # Adds the group keyword argument to the initializer, ensures the type
        # is [Socializer::Group], and creates a private reader
        option :group, type: Types.Strict(Group), reader: :private

        # Adds the person keyword argument to the initializer, ensures the type
        # is [Socializer::Person], and creates a private reader
        option :person, type: Types.Strict(Person), reader: :private

        # @return [Socializer::Membership] Deletes the record in the
        # database and freezes this instance to reflect that no changes should
        # be made (since they can't be persisted). If the before_destroy
        # callback returns false the action is cancelled and leave returns
        # false.
        def call
          raise(NotImplementedError, "You must implement the call method")
        end
      end
    end
  end
end
