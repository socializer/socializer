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
    #     helpers.content_tag :span, class: "time" do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end

    # Removes the module part from the activitable_type
    #
    # @return [String]
    def demodulized_type
      model.activitable_type.demodulize
    end

    # Builds the like or unlike link
    #
    # @return [String] the html needed to display the like/unlike link
    def link_to_like_or_unlike
      return unless helpers.current_user

      attributes = current_user_likes? ? like_attributes : unlike_attributes

      like_or_unlike_link(attributes: attributes)
    end

    private

    def like_attributes
      path  = helpers.unlike_activity_path(model)
      # i18n-tasks-use t("socializer.shared.unlike")
      title = helpers.t("socializer.shared.unlike")

      LikeLinkAttributes.new(class_name: "btn-danger",
                             path: path,
                             title: title,
                             verb: :delete)
    end

    def unlike_attributes
      path  = helpers.like_activity_path(model)
      # i18n-tasks-use t("socializer.shared.like")
      title = helpers.t("socializer.shared.like")

      LikeLinkAttributes.new(class_name: "btn-default",
                             path: path,
                             title: title,
                             verb: :post)
    end

    def like_or_unlike_link(attributes:)
      content = like_or_unlike_content

      helpers.link_to(content,
                      attributes.path,
                      method: attributes.verb,
                      remote: true,
                      class: "btn #{attributes.class_name}",
                      title: attributes.title,
                      data: { behavior: "tooltip-on-hover" })
    end

    def like_or_unlike_content
      like_count = model.like_count
      content    = helpers.content_tag(:span,
                                       nil,
                                       class: "fa fa-fw fa-thumbs-o-up")

      content += like_count.to_s.html_safe if like_count > 0
      content
    end

    def current_user_likes?
      @current_user_likes ||= helpers.current_user.likes?(model)
    end
  end
end
