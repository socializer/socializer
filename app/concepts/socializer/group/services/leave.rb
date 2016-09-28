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
      # Leave a group
      #
      class Leave < ServiceBase
        # @return [Socializer:Membership/FalseClass] Deletes the record in the
        # database and freezes this instance to reflect that no changes should
        # be made (since they can't be persisted). If the before_destroy
        # callback returns false the action is cancelled and leave returns
        # false.
        def call
          # TODO: Need a guard statement if no members
          membership = group.memberships
                            .find_by(activity_member: person.activity_object)

          membership.destroy
        end
      end
    end
  end
end
