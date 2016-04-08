#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Class LikeLinkAttributes provides <description>
  #
  class LikeLinkAttributes
    attr_reader :class_name, :path, :title, :verb

    # Initializer
    #
    # @param [String] class_name: <description>
    # @param [String] path: <description>
    # @param [String] title: <description>
    # @param [Symbol] verb: <description>
    def initialize(class_name:, path:, title:, verb:)
      @class_name = class_name
      @path = path
      @title = title
      @verb = verb
    end
  end
end
