# frozen_string_literal: true

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
    #     helpers.tag.span(class: 'time') do
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

      options = current_user_likes? ? like_options : unlike_options

      like_or_unlike_link(options:)
    end

    private

    def default_options
      { remote: true, data: { behavior: "tooltip-on-hover" } }
    end

    def like_options
      path  = helpers.unlike_activity_path(model)
      # i18n-tasks-use t("socializer.shared.unlike")
      title = helpers.t("socializer.shared.unlike")

      { class: "btn btn-danger", path:, title:, method: :delete }
    end

    def unlike_options
      path  = helpers.like_activity_path(model)
      # i18n-tasks-use t("socializer.shared.like")
      title = helpers.t("socializer.shared.like")

      { class: "btn btn-default", path:, title:, method: :post }
    end

    def like_or_unlike_link(options:)
      path = options.delete(:path)

      options.merge!(default_options)

      helpers.link_to(like_or_unlike_content, path, options)
    end

    def like_or_unlike_content
      content = []
      like_count = model.like_count

      content << helpers.tag.span(class: "fa fa-fw fa-thumbs-o-up")

      content << like_count.to_s if like_count.positive?
      helpers.safe_join(content)
    end

    def current_user_likes?
      return @current_user_likes if defined?(@current_user_likes)

      @current_user_likes = helpers.current_user.likes?(model)
    end
  end
end
