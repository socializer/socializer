#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators for {Socializer::Circle}
  class CircleDecorator < Draper::Decorator
    delegate_all

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: "time" do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end

    # The number of ties for the decorated {Socializer::Circle}
    #
    # @return [String]
    def ties_count
      helpers.pluralize(model.ties_count, "person")
    end
  end
end
