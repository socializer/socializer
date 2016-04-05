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

        # @return [Socializer:Membership/FalseClass] Deletes the record in the
        # database and freezes this instance to reflect that no changes should
        # be made (since they can't be persisted). If the before_destroy
        # callback returns false the action is cancelled and leave returns
        # false.
        def call
          raise(NotImplementedError, "You must implement the call method")
        end

        private

        def wrong_type_message(instance:, valid_class:)
          valid_class_name = valid_class.name

          I18n.t("socializer.errors.messages.wrong_instance_type",
                 argument: valid_class_name.downcase,
                 valid_class: valid_class_name,
                 invalid_class: instance.class.name)
        end
      end
    end
  end
end
