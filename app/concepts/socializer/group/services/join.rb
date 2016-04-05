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
      # Add a member to a group
      #
      class Join < ServiceBase
        # @return [Socializer:Membership/ActiveRecord::RecordInvalid] The
        # resulting object is returned if validations passes.
        # Raises ActiveRecord::RecordInvalid when the record is invalid.
        def call
          active = true if @group.privacy.public?
          active = false if @group.privacy.restricted?

          if @group.privacy.private?
            raise(Errors::PrivateGroupCannotSelfJoin)
            # TODO: add errors to base, make it a validation problem instead of
            # failing
            #
            # Need to check errors or something before running create!.
            # Check valid?
            # This else condition is really privacy.private? we could return
            # the errors.add and see if that shows in the view
            # person.memberships.errors.add(:base, message)
            # errors.add(:base, message)
          end

          @group.memberships.create!(activity_member: @person.activity_object,
                                     active: active)
        end
      end
    end
  end
end
