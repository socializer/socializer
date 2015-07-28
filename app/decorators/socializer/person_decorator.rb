#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators for {Socializer::Person}
  class PersonDecorator < ApplicationDecorator
    delegate_all

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: "time" do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end

    # The location/url of the persons avatar
    #
    # @example
    #   current_user.avatar_url
    #
    # @return [String]
    #
    def avatar_url
      avatar_provider_array = %w( FACEBOOK LINKEDIN TWITTER )

      if avatar_provider_array.include?(avatar_provider)
        social_avatar_url(avatar_provider)
      else
        gravatar_url
      end
    end

    # Format the birthdate attribute
    #
    # @return [String]
    def birthdate
      model.birthdate? ? model.birthdate.to_s(:long_ordinal) : nil
    end

    # Creates an image tag for the persons avatar
    #
    # @param size: nil [String]
    # @param css_class: nil [String]
    # @param alt: "Avatar" [String]
    # @param title: nil [String]
    #
    # @return [String]  An HTML image tag
    def image_tag_avatar(size: nil, css_class: nil, alt: "Avatar", title: nil)
      helpers.image_tag(avatar_url,
                        size: size,
                        class: css_class,
                        alt: alt,
                        title: title,
                        data: { behavior: "tooltip-on-hover" })
    end

    # Creates a link to the persons profile with their avatar as the content
    #
    # @return [String] An HTML a tag
    def link_to_avatar
      helpers.link_to(image_tag_avatar(title: model.display_name),
                      helpers.person_activities_path(person_id: model.id))
    end

    # Builds the links for the shared toolbar
    #
    # @return [String] the html needed to display the toolbar links
    def toolbar_stream_links
      list = combine_circles_and_memberships
      return if list.blank?

      html = []
      html << toolbar_links(list[0..2])
      html << toolbar_dropdown(list[3..(list.size)])

      html.join.html_safe
    end

    private

    def combine_circles_and_memberships
      model.circles + model.memberships
    end

    def social_avatar_url(provider)
      auth = authentications.by_provider(provider: provider).first
      auth.image_url if auth.present?
    end

    def gravatar_url
      return if email.blank?
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
    end

    def toolbar_dropdown(list)
      helpers.content_tag(:li, class: "dropdown") do
        dropdown_link +
          helpers.content_tag(:ul, class: "dropdown-menu") do
            toolbar_links(list)
          end
      end
    end

    def dropdown_link
      css_class = "dropdown-toggle"
      icon      = helpers.content_tag(:span, nil,
                                      class: "fa fa-angle-down fa-fw")

      helpers.link_to("#", class: css_class, data: { toggle: "dropdown" }) do
        "#{helpers.t('socializer.shared.toolbar.more')} #{icon}".html_safe
      end
    end

    # Check if the url is the current page
    #
    # @param url: [String] The url to check
    #
    # @return [String/Nil] Returns "active" if the url is the current page.
    def toolbar_item_class(url:)
      "active" if helpers.current_page?(url)
    end

    def toolbar_links(list)
      list.map do |item|
        toolbar_link(item)
      end.join.html_safe
    end

    # Check if the object is an instance of {Socializer::Membership}
    #
    # @param object:
    #
    # @return [Socializer::Group]
    def toolbar_object(object:)
      return object.group if object.is_a?(Socializer::Membership)
      object
    end

    def toolbar_link(item)
      item       = toolbar_object(object: item)
      url_prefix = item.class.name.demodulize.downcase
      url        = helpers.public_send("#{url_prefix}_activities_path", item.id)
      class_name = toolbar_item_class(url: url)

      helpers.content_tag(:li) do
        helpers.link_to(item.display_name, url, class: class_name)
      end
    end
  end
end
