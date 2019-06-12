# frozen_string_literal: true

require "dry-types"

#
# Namespace for dry-type types
#
module Types
  include Dry.Types

  StrippedString = Types::String.constructor(&:strip)
  LowercaseString = Types::String.constructor(&:downcase)
end
