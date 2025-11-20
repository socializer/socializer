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

    # Returns the base options merged into the like/unlike link options.
    # These defaults enable unobtrusive (AJAX) requests and attach a tooltip-on-hover
    # behavior to the generated link element.
    #
    # @return [Hash] default HTML/options (keys: :remote, :data)
    #
    # @example
    #   default_options
    #   # => { remote: true, data: { behavior: "tooltip-on-hover" } }
    def default_options
      { remote: true, data: { behavior: "tooltip-on-hover" } }
    end

    # Builds the options hash used when rendering the "unlike" link (for when the
    # activity is already liked by the current user). Includes CSS class, the
    # target path, a localized title and the HTTP method to use.
    #
    # @return [Hash] options suitable for `helpers.link_to` (keys: :class, :path, :title, :method)
    #
    # @example
    #   # => { class: "btn btn-danger", path: helpers.unlike_activity_path(activity), title: "Unlike", method: :delete }
    def like_options
      path  = helpers.unlike_activity_path(model)
      # i18n-tasks-use t("socializer.shared.unlike")
      title = helpers.t("socializer.shared.unlike")

      { class: "btn btn-danger", path:, title:, method: :delete }
    end

    # Builds the options hash used when rendering the "like" link (for when the
    # activity is not yet liked by the current user). Includes CSS class, the
    # target path, a localized title and the HTTP method to use.
    #
    # @return [Hash] options suitable for `helpers.link_to` (keys: :class, :path, :title, :method)
    #
    # @example
    #   # => { class: "btn btn-default", path: helpers.like_activity_path(activity), title: "Like", method: :post }
    def unlike_options
      path  = helpers.like_activity_path(model)
      # i18n-tasks-use t("socializer.shared.like")
      title = helpers.t("socializer.shared.like")

      { class: "btn btn-default", path:, title:, method: :post }
    end

    # Builds and returns the HTML-safe link for liking or unliking the activity.
    # Extracts the `:path` from the provided `options`, merges in `default_options`,
    # and delegates to `helpers.link_to` using `like_or_unlike_content` as the link body.
    #
    # @param options [Hash] options used to build the link. Must include `:path` (will be removed).
    #
    # @return [ActiveSupport::SafeBuffer] HTML-safe anchor element for the like/unlike action.
    #
    # @example
    #   # Assuming `decorator` is an ActivityObjectDecorator for an activity:
    #   decorator.like_or_unlike_link(options: { path: helpers.like_activity_path(activity), class: "btn" })
    def like_or_unlike_link(options:)
      path = options.delete(:path)

      options.merge!(default_options)

      helpers.link_to(like_or_unlike_content, path, options)
    end

    # Returns an HTML-safe fragment used as the content for the like/unlike link.
    # Composes an icon and the activity's like count (only shown if positive),
    # then joins the pieces safely so it can be used directly inside a link.
    #
    # @return [ActiveSupport::SafeBuffer] HTML-safe content for the link
    #
    # @example
    #   # when like_count == 3
    #   decorator.like_or_unlike_content # => "<span class=\"fa fa-fw fa-thumbs-o-up\"></span>3"
    def like_or_unlike_content
      content = []
      like_count = model.like_count

      content << helpers.tag.span(class: "fa fa-fw fa-thumbs-o-up")

      content << like_count.to_s if like_count.positive?
      helpers.safe_join(content)
    end

    # Returns whether the currently signed-in user has liked this activity.
    # The result is memoized in `@current_user_likes` to avoid repeated database calls.
    #
    # @return [Boolean]
    #
    # @example
    #   # assuming `helpers.current_user` is set and `model` is an activity
    #   decorator.current_user_likes? # => true
    def current_user_likes?
      return @current_user_likes if defined?(@current_user_likes)

      @current_user_likes = helpers.current_user.likes?(model)
    end
  end
end
