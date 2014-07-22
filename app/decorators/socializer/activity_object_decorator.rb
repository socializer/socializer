#
# Namespace for the Socializer engine
#
module Socializer
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
    # @param current_user [Socializer::Person]
    #
    # @return [String] the html needed to display the like/unlike link

    # TODO: Need to take into account the like/unlike for comments. Need to be able to pass the style in for the btn
    #       and the icon
    def link_to_like_or_unlike(current_user:)
      return unless current_user

      content   = like_or_unlike_content(activity_object: model)
      variables = like_or_unlike_variables(current_user: current_user)

      helpers.link_to(content, variables.path, method: variables.verb, remote: true, class: variables.link_class, title: variables.tooltip)
    end

    private

    def like_or_unlike_content(activity_object:)
      content = helpers.content_tag(:span, nil, class: 'fa fa-fw fa-thumbs-o-up')
      content += "#{activity_object.like_count}".html_safe if activity_object.like_count > 0
      content
    end

    def like_or_unlike_variables(current_user:)
      return variables_if_user_likes if current_user.likes?(model)
      variables_if_user_does_not_like
    end

    def variables_if_user_likes
      path       = helpers.stream_unlike_path(model)
      link_class = 'btn btn-danger'

      OpenStruct.new(path: path, verb: :delete, link_class: link_class, tooltip: helpers.t('socializer.shared.unlike'))
    end

    def variables_if_user_does_not_like
      path       = helpers.stream_like_path(model)
      link_class = 'btn btn-default'

      OpenStruct.new(path: path, verb: :post, link_class: link_class, tooltip: helpers.t('socializer.shared.like'))
    end
  end
end
