#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators for {Socializer::ActivityObject}
  class ActivityObjectDecorator < Draper::Decorator
    delegate_all

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: 'time' do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end

    # Builds the like or unlike link
    #
    # @return [String] the html needed to display the like/unlike link
    def link_to_like_or_unlike
      return unless helpers.current_user

      content   = like_or_unlike_content
      variables = like_or_unlike_variables

      helpers.link_to(content, variables.path, method: variables.verb,
                                               remote: true,
                                               class: variables.link_class,
                                               title: variables.tooltip)
    end

    private

    def like_or_unlike_content
      content = helpers.content_tag(:span, nil, class: 'fa fa-fw fa-thumbs-o-up')
      content += "#{model.like_count}".html_safe if model.like_count > 0
      content
    end

    def like_or_unlike_variables
      return like_or_unlike_openstruct unless helpers.current_user.likes?(model)

      path       = helpers.unlike_activity_path(model)
      link_class = 'btn-danger'
      tooltip    = 'unlike'
      verb       = :delete

      like_or_unlike_openstruct(path: path, verb: verb, link_class: link_class, tooltip: tooltip)
    end

    def like_or_unlike_openstruct(path: helpers.like_activity_path(model), verb: :post, link_class: 'btn-default', tooltip: 'like')
      tooltip = helpers.t("socializer.shared.#{tooltip}")
      OpenStruct.new(path: path, verb: verb, link_class: "btn #{link_class}", tooltip: tooltip)
    end
  end
end
