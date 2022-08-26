# frozen_string_literal: true

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
      # Invite a member to join the group
      #
      class Invite < ServiceBase
        # @return [Socializer::Membership]
        #   The resulting object is returned. If validations passes.
        # @raise [ActiveRecord::RecordInvalid] if the record is invalid.
        def call
          group.memberships.create!(activity_member: person.activity_object,
                                    active: false)
        end
      end
    end
  end
end
