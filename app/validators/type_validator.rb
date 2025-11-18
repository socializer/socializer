# frozen_string_literal: true

# Class TypeValidator provides a custom validator which ensures an object
# is an instance of a class
class TypeValidator < ActiveModel::EachValidator
  include Socializer::Utilities::Message

  # Validates that the value of the specified attribute is an instance of the expected type.
  #
  # @param record [Object] the object being validated
  # @param attribute [Symbol] the attribute being validated
  # @param value [Object] the value of the attribute
  #
  # @example
  #   validates :attribute_name, type: { with: String }
  def validate_each(record, attribute, value)
    expected_type = options[:with]

    return if value.is_a?(expected_type)

    message = options[:message] ||
              wrong_type_message(instance: value, valid_class: expected_type)

    # message = options[:message] ||
    #           "is class #{value.class}, not #{expected_type}"

    record.errors.add attribute, message
  end
end
