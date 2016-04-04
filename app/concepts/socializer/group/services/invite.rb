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
      class Invite
        # Initializer
        #
        # @param [Socializer:Group] group: the group to invite the person to
        # @param [Socializer:Person] person: the person that is being invited
        # to the group
        #
        # @return [Socializer::Group::Services::Invite] returns an instance of
        # Invite
        def initialize(group:, person:)
          # TODO: Change to a validation
          unless group.is_a?(Socializer::Group)
            raise(ArgumentError,
                  wrong_type_message(instance: group, valid_class: Group))
          end

          # TODO: Change to a validation
          unless person.is_a?(Socializer::Person)
            raise(ArgumentError,
                  wrong_type_message(instance: person, valid_class: Person))
          end

          @group  = group
          @person = person
        end

        # @return [Socializer:Membership/ActiveRecord::RecordInvalid] The
        # resulting object is returned if validations passes.
        # Raises ActiveRecord::RecordInvalid when the record is invalid.
        def call
          @group.memberships.create!(activity_member: @person.activity_object,
                                     active: false)
        end

        private

        def wrong_type_message(instance:, valid_class:)
          I18n.t("socializer.errors.messages.wrong_instance_type",
                 argument: "person",
                 valid_class: valid_class.name,
                 invalid_class: instance.class.name)
        end
      end
    end
  end
end
