# frozen_string_literal: true

require "dry/types"

#
# Namespace for dry/type types
#
module Types
  include Dry.Types

  StrippedString = Types::String.constructor(&:strip)
  LowercaseString = Types::String.constructor(&:downcase)

  # NOTE: Check Verbs against ActivityStreams 2.0.
  #       post -> create or add depending on the context
  #       share -> announce with audience targeting
  #       unlike -> undo where object is the like
  #       {
  #         "type": "Undo",
  #         "object": {
  #           "type": "Like",
  #           "object": "http://foo.example/obj/blarg/"
  #       }
  #     }
  ActivityVerbs = Types::String.enum("add", "like", "post", "share", "unlike")
end
