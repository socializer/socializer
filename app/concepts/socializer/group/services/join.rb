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
      # Add a member to a group
      #
      class Join < ServiceBase
        # @return [Socializer::Membership] if
        #   validations pass the resulting object is returned.
        # @raise [ActiveRecord::RecordInvalid] when the record is invalid.
        def call
          privacy = group.privacy

          active = true if privacy.public?
          active = false if privacy.restricted?

          if privacy.private?
            raise(Errors::PrivateGroupCannotSelfJoin)
            # TODO: add errors to base, make it a validation problem instead of
            #       failing
            #
            # Need to check errors or something before running create!.
            # Check valid?
            # This else condition is really privacy.private? we could return
            # the errors.add and see if that shows in the view
            # message = Errors::PrivateGroupCannotSelfJoin.new.message
            # person.memberships.errors.add(:base, message)
            # add the error to the field
            # group.errors.add(:privacy, :invalid, message)
          end

          group.memberships.create!(activity_member: person.activity_object,
                                    active:)
        end
      end
    end
  end
end
