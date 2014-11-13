module Socializer
  class PersonDecorator < ApplicationDecorator
    delegate_all

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: 'time' do
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
    # @param alt: 'Avatar' [String]
    # @param title: nil [String]
    #
    # @return [String]  An HTML image tag
    def image_tag_avatar(size: nil, css_class: nil, alt: 'Avatar', title: nil)
      helpers.image_tag(avatar_url, size: size, class: css_class, alt: alt, title: title)
    end

    # Creates a link to the persons profile with their avatar as the content
    #
    # @return [String] An HTML a tag
    def link_to_avatar
      helpers.link_to(image_tag_avatar(title: model.display_name), helpers.stream_path(provider: :people, id: model.id))
    end

    # Builds the links for the shared toolbar
    #
    # @return [String] the html needed to display the toolbar links
    def toolbar_stream_links
      list = model.circles + model.memberships
      return if list.blank?

      html = []
      html << toolbar_links(list[0..2])
      html << toolbar_dropdown(list[3..(list.size)])

      html.join.html_safe
    end

    private

    def social_avatar_url(provider)
      auth = authentications.by_provider(provider).first
      auth.image_url if auth.present?
    end

    def gravatar_url
      return if email.blank?
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
    end

    def toolbar_dropdown(list)
      helpers.content_tag(:li, class: 'dropdown') do
        dropdown_link +

        helpers.content_tag(:ul, class: 'dropdown-menu') do
          toolbar_links(list)
        end
      end
    end

    def dropdown_link
      icon = helpers.content_tag(:span, nil, class: 'fa fa-angle-down fa-fw')
      helpers.link_to('#', class: 'dropdown-toggle', data: { toggle: 'dropdown' }) do
        # TODO: should be able to use relative keys. Doesn't work in test
        "#{helpers.t('socializer.shared.toolbar.more')} #{icon}".html_safe
      end
    end

    def toolbar_links(list)
      list.map do |item|
        toolbar_link(item)
      end.join.html_safe
    end

    def toolbar_link(item)
      item       = item.group if item.is_a?(Socializer::Membership)
      item_id    = item.id
      provider   = item.class.name.demodulize.tableize.to_sym
      class_name = 'active' if helpers.current_page?(helpers.stream_path(provider: provider, id: item_id))

      helpers.content_tag(:li) do
        helpers.link_to(item.display_name, helpers.stream_path(provider: provider, id: item_id), class: class_name)
      end
    end
  end
end
