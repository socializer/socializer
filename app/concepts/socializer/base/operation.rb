# frozen_string_literal: true

require "dry/monads"
require "dry/monads/do"

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Base namespace
  #
  module Base
    #
    # Base operation class
    #
    class Operation
      def self.inherited(klass)
        super

        klass.class_eval do
          include Dry::Monads[:result, :do]
          include Dry::Monads::Do.for(:call)
        end
      end
    end
  end
end
