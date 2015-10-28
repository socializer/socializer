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
      like_or_unlike_link if helpers.current_user
    end

    private

    def like_or_unlike_link
      content = like_or_unlike_content

      helpers.link_to(content,
                      like_or_unlike_path,
                      method: like_or_unlike_verb,
                      remote: true,
                      class: "btn #{like_or_unlike_class}",
                      title: like_or_unlike_title,
                      data: { behavior: "tooltip-on-hover" })
    end

    def like_or_unlike_content
      content = helpers.content_tag(:span,
                                    nil,
                                    class: "fa fa-fw fa-thumbs-o-up")

      content += "#{model.like_count}".html_safe if model.like_count > 0
      content
    end

    def like_or_unlike_class
      return "btn-danger" if current_user_likes?
      "btn-default"
    end

    def like_or_unlike_path
      return helpers.unlike_activity_path(model) if current_user_likes?
      helpers.like_activity_path(model)
    end

    def like_or_unlike_title
      # i18n-tasks-use t("socializer.shared.unlike")
      return helpers.t("socializer.shared.unlike") if current_user_likes?
      # i18n-tasks-use t("socializer.shared.like")
      helpers.t("socializer.shared.like")
    end

    def like_or_unlike_verb
      return :delete if current_user_likes?
      :post
    end

    def current_user_likes?
      @current_user_likes ||= helpers.current_user.likes?(model)
    end
  end
end
