# frozen_string_literal: true

# Class TypeValidator provides a custom validator which ensures an object
# is an instance of a class
class TypeValidator < ActiveModel::EachValidator
  include Socializer::Utilities::Message

  # Validate that the value is the type we expect
  #
  # @param [Object] record: the instance
  # @param [Symbol] attribute: the attribute to be validated
  # @param [Object] value: the value of the attribute in the passed instance
  #
  # @return [nil]
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
