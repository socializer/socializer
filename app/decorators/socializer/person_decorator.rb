# frozen_string_literal: true

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
    #     helpers.tag.span, class: "time" do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end

    #  Attributes

    # Format the birthdate attribute
    #
    # @return [String]
    def birthdate
      model.birthdate? ? model.birthdate.to_s(:long_ordinal) : nil
    end

    # Returns the capitalized gender
    #
    # @return [String]
    def gender
      model.gender.titleize
    end

    # Returns the occupation value or "What do you do?" when occupation is nil
    #
    # @return [String]
    def occupation
      model.occupation || "What do you do?"
    end

    # Returns the other_names value or "For example: maiden name, alternate
    # spellings"
    #
    # @return [String]
    def other_names
      model.other_names || "For example: maiden name, alternate spellings"
    end

    # Returns the capitalized relationship or "Seeing anyone?" if the
    # relationship value is unknown
    #
    # @return [String]
    def relationship
      relationship = model.relationship

      return "Seeing anyone?" if relationship.unknown?

      relationship.titleize
    end

    # Returns the skills value or "What are your skills?" when skills is nil
    #
    # @return [String]
    def skills
      model.skills || "What are your skills?"
    end

    # The location/url of the persons avatar
    #
    # @example
    #   current_user.avatar_url
    #
    # @return [String]
    #
    def avatar_url
      avatar_providers = Set.new(%w[FACEBOOK LINKEDIN TWITTER])

      # REFACTOR: Should an authentications decorator be created? If so,
      # override the image_url method using this
      # logic, or we can create an avatar_url method
      return social_avatar_url if avatar_providers.include?(avatar_provider)

      gravatar_url
    end

    # The number of contacts for the decorated {Socializer::Person}
    #
    # @return [String]
    def contacts_count
      helpers.pluralize(model.contacts_count, "person")
    end

    # The number of {Socializer::Person people} this Socializer::Person person}
    # is a contact of
    #
    # @return [String]
    def contact_of_count
      helpers.pluralize(model.contact_of.count, "person")
    end

    # Creates an image tag for the persons avatar
    #
    # @param [String] size: nil
    # @param [String] css_class: nil
    # @param [String] alt: "Avatar"
    # @param [String] title: nil
    #
    # @return [String]  An HTML image tag
    def image_tag_avatar(size: nil, css_class: nil, alt: "Avatar", title: nil)
      width, height = parse_size(size:) if size

      helpers.tag.img(src: avatar_url, class: css_class, alt:,
                      title:, width:, height:,
                      data: { behavior: "tooltip-on-hover" })
    end

    # Creates a link to the persons profile with their avatar as the content
    #
    # @return [String] An HTML a tag
    def link_to_avatar
      helpers.link_to(image_tag_avatar(title: model.display_name),
                      helpers.person_activities_path(person_id: model.id))
    end

    # Returns what relationships the {Socializer::Person person} is looking for
    #
    # @return [String]
    def looking_for
      content = [looking_for_friends,
                 looking_for_dating,
                 looking_for_relationship,
                 looking_for_networking]

      content << looking_for_who if content.join.empty?

      helpers.safe_join(content)
    end

    # Builds the links for the shared toolbar
    #
    # @return [String] the html needed to display the toolbar links
    def toolbar_stream_links
      list = combine_circles_and_memberships
      return if list.blank?

      html = [toolbar_links(list[0..2])]
      html << toolbar_dropdown(list[3..(list.size)])

      helpers.safe_join(html)
    end

    private

    def content_and_br(content:)
      [content, helpers.tag.br]
    end

    def looking_for_friends
      content_and_br(content: "Friends") if model.looking_for_friends?
    end

    def looking_for_dating
      content_and_br(content: "Dating") if model.looking_for_dating?
    end

    def looking_for_relationship
      content_and_br(content: "Relationship") if model.looking_for_relationship?
    end

    def looking_for_networking
      content_and_br(content: "Networking") if model.looking_for_networking?
    end

    def looking_for_who
      "Who are you looking for?"
    end

    def combine_circles_and_memberships
      model.circles + model.memberships
    end

    def social_avatar_url
      auth = authentications.find_by(provider: avatar_provider.downcase)
      auth.image_url if auth.present?
    end

    def gravatar_url
      return if email.blank?

      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
    end

    def parse_size(size:)
      size = size.to_s

      return size.split("x") if /\A\d+x\d+\z/.match?(size)

      [size, size] if /\A\d+\z/.match?(size)
    end

    def toolbar_dropdown(list)
      helpers.tag.li(class: "dropdown") do
        dropdown_link +
          helpers.tag.ul(class: "dropdown-menu") do
            toolbar_links(list)
          end
      end
    end

    def dropdown_link
      css_class = "dropdown-toggle"
      icon      = helpers.tag.span(class: "fa fa-angle-down fa-fw")

      # i18n-tasks-use t("socializer.shared.toolbar.more")
      content = [helpers.t("socializer.shared.toolbar.more"), icon]

      helpers.link_to("", class: css_class, data: { toggle: "dropdown" }) do
        helpers.safe_join(content)
      end
    end

    # Check if the url is the current page
    #
    # @param url: [String] The url to check
    #
    # @return [String]/[NilClass] Returns "active" if the url is the
    # current page.
    def toolbar_item_class(url:)
      "active" if helpers.current_page?(url)
    end

    def toolbar_links(list)
      links = list.map do |item|
        toolbar_link(item)
      end

      helpers.safe_join(links)
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

    # REFACTOR: May make more sense to put this in the application decorator
    # without the is_a? check and put the method
    # in a membership decorator that assigns item = item.group.
    # This should be refactored into a more generic toolbar_nav_link
    # application decorator method. This should then be
    # refactored to use that method from the ApplicationDecorator. See the
    # toolbar partials for the initial requirements
    def toolbar_link(item)
      item = toolbar_object(object: item)
      url  = toolbar_link_url(item:)
      class_name = toolbar_item_class(url:)

      helpers.tag.li do
        helpers.link_to(item.display_name, url, class: class_name)
      end
    end

    def toolbar_link_url(item:)
      url_prefix = item.class.name.demodulize.downcase
      helpers.public_send("#{url_prefix}_activities_path", item.id)
    end
  end
end
