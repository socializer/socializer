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
    # @return [String, nil]
    def birthdate
      model.birthdate? ? model.birthdate.to_fs(:long_ordinal) : nil
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
    # @return [String]
    #
    # @example
    #   current_user.avatar_url
    def avatar_url
      avatar_providers = Set.new(%w[FACEBOOK LINKEDIN TWITTER])

      # REFACTOR: Should an authentications decorator be created? If so,
      #   override the image_url method using this
      #   logic, or we can create an avatar_url method
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

    # Creates an image tag for the person's avatar
    #
    # @param size [String] The size of the avatar (optional)
    # @param css_class [String] The CSS class for the image tag (optional)
    # @param alt [String] The alt text for the image (default: "Avatar")
    # @param title [String] The title text for the image (optional)
    #
    # @return [String] An HTML image tag
    #
    # @example
    #   image_tag_avatar(size: "100x100", css_class: "avatar", alt: "User Avatar", title: "User")
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

    # Returns the given `content` paired with an HTML line break element.
    #
    # This helper is used by the `looking_for_*` helpers to return a label
    # together with a `<br>` so `helpers.safe_join` can render them correctly.
    #
    # @param content [String] the text content to pair with a line break
    #
    # @return [Array] an array containing the content and `helpers.tag.br`
    # @example
    #   content_and_br(content: "Friends")
    #   # => ["Friends", helpers.tag.br]
    def content_and_br(content:)
      [content, helpers.tag.br]
    end

    # Returns the "Friends" label paired with a line break when the person
    # is looking for friends. This is consumed by {#looking_for}, which safely
    # joins returned fragments into the final markup.
    #
    # @return [Array, nil] An array containing the label and a `<br>` element
    #   when `model.looking_for_friends?` is true, otherwise `nil`.
    #
    # @example
    #   # Given `model.looking_for_friends? #=> true`
    #   #   looking_for_friends
    #   #   # => ["Friends", helpers.tag.br]
    def looking_for_friends
      content_and_br(content: "Friends") if model.looking_for_friends?
    end

    # Returns the "Dating" label paired with a line break when the person
    # is looking for dating. Consumed by {#looking_for}, which safely joins
    # returned fragments into the final markup.
    #
    # @return [Array, nil] An array containing the label and a `<br>` element
    #   when `model.looking_for_dating?` is true, otherwise `nil`.
    #
    # @example
    #   # Given `model.looking_for_dating? #=> true`
    #   #   looking_for_dating
    #   #   # => ["Dating", helpers.tag.br]
    def looking_for_dating
      content_and_br(content: "Dating") if model.looking_for_dating?
    end

    # Returns the "Relationship" label paired with a line break when the person
    # is looking for a relationship. This is consumed by {#looking_for}, which
    # safely joins returned fragments into the final markup.
    #
    # @return [Array, nil] An array containing the label and a `<br>` element
    #   when `model.looking_for_relationship?` is true, otherwise `nil`.
    #
    # @example
    #   # Given `model.looking_for_relationship? #=> true`
    #   #   looking_for_relationship
    #   #   # => ["Relationship", helpers.tag.br]
    def looking_for_relationship
      content_and_br(content: "Relationship") if model.looking_for_relationship?
    end

    # Returns the "Networking" label paired with a line break when the person
    # is looking for networking. This is consumed by {#looking_for}, which
    # safely joins returned fragments into the final markup.
    #
    # @return [Array, nil] An array of the label and a `<br>` element when
    #   `model.looking_for_networking?` is true, otherwise `nil`.
    #
    # @example
    #   # Given `model.looking_for_networking? #=> true`
    #   #   looking_for_networking
    #   #   # => ["Networking", helpers.tag.br]
    def looking_for_networking
      content_and_br(content: "Networking") if model.looking_for_networking?
    end

    # Returns a prompt string when no specific "looking for" options are set.
    # Used as a fallback by {#looking_for} to prompt the user.
    #
    # @return [String] a question prompting who the person is looking for
    #
    # @example
    #   # In a decorator/view context:
    #   #   decorator.looking_for_who
    #   #   # => "Who are you looking for?"
    def looking_for_who
      "Who are you looking for?"
    end

    # Combines the person's circles and memberships into a single array.
    #
    # Returns an array containing the person's circles followed by their
    # memberships. Useful for building combined lists for toolbars and menus.
    #
    # @return [Array<Socializer::Circle, Socializer::Membership>]
    #
    # @example
    #   # Given a person with two circles and one membership:
    #   #   combine_circles_and_memberships
    #   #   # => [circle1, circle2, membership1]
    def combine_circles_and_memberships
      model.circles + model.memberships
    end

    # Returns the avatar URL obtained from the user's social authentication record.
    # Looks up the authentication matching the configured `avatar_provider` (downcased)
    # and returns its `image_url` when present.
    #
    # @return [String, nil] the image URL from the authentication or `nil` if none found
    #
    # @example
    #   # Given:
    #   #   avatar_provider #=> "FACEBOOK"
    #   #   authentications.find_by(provider: "facebook").image_url #=> "https://..."
    #   #
    #   social_avatar_url #=> "https://..."
    def social_avatar_url
      auth = authentications.find_by(provider: avatar_provider.downcase)
      auth.presence&.image_url
    end

    # Generates the Gravatar URL for the person's email address.
    #
    # The email is normalized by downcasing and stripping whitespace, then hashed
    # using SHA256. Returns nil when the email is blank.
    #
    # @return [String, nil] the Gravatar image URL or nil when no email is present
    #
    # @example
    #   # Given:
    #   #   email = "user@example.com"
    #   # Then:
    #   #   gravatar_url
    #   #   # => "https://www.gravatar.com/avatar/#{Digest::SHA256.hexdigest('user@example.com')}"
    def gravatar_url
      return if email.blank?

      hash = Digest::SHA256.hexdigest(email.downcase.strip)

      "https://www.gravatar.com/avatar/#{hash}"
    end

    # Parses a size specification and returns width and height components.
    #
    # Accepts sizes in the form "WIDTHxHEIGHT" (e.g. "100x200") or a single
    # numeric value (e.g. "50" or 50) which will be used for both width and height.
    #
    # @param size [String, Integer] The requested size specification.
    #
    # @return [Array<String>, nil] An array of two strings \[width, height\] when
    #   the input matches a recognized format, otherwise nil.
    #
    # @example
    #   parse_size(size: "100x200") # => ["100", "200"]
    #   parse_size(size: "50")      # => ["50", "50"]
    def parse_size(size:)
      size = size.to_s

      return size.split("x") if /\A\d+x\d+\z/.match?(size)

      [size, size] if /\A\d+\z/.match?(size)
    end

    # Builds a dropdown list item that contains a toggle link and a nested
    # unordered list of toolbar links.
    #
    # @param list [Enumerable] collection of items (e.g. circles, memberships) to render inside the dropdown
    #
    # @return [String] HTML-safe list item containing the dropdown toggle and menu
    #
    # @example
    #   # Returns an li.dropdown element with a toggle and an inner ul.dropdown-menu
    #   toolbar_dropdown([circle1, circle2, membership])
    #   # => "<li class=\"dropdown\">...<ul class=\"dropdown-menu\">...</ul></li>"
    def toolbar_dropdown(list)
      helpers.tag.li(class: "dropdown") do
        dropdown_link +
          helpers.tag.ul(class: "dropdown-menu") do
            toolbar_links(list)
          end
      end
    end

    # Builds the dropdown toggle link used by the toolbar.
    #
    # Generates an anchor tag with the CSS class and data attributes required
    # to toggle the dropdown menu (compatible with Bootstrap-style dropdowns).
    #
    # @return [String] HTML-safe anchor element used as the dropdown toggle.
    #
    # @example
    #   # In a decorator/view context:
    #   dropdown_link
    #   # => "<a class=\"dropdown-toggle\" data-toggle=\"dropdown\">More <span class=\"fa fa-angle-down fa-fw\"></span></a>"
    def dropdown_link
      css_class = "dropdown-toggle"
      icon      = helpers.tag.span(class: "fa fa-angle-down fa-fw")

      # i18n-tasks-use t("socializer.shared.toolbar.more")
      content = [helpers.t("socializer.shared.toolbar.more"), icon]

      helpers.link_to("", class: css_class, data: { toggle: "dropdown" }) do
        helpers.safe_join(content)
      end
    end

    # Check if the URL is the current page
    #
    # @param url [String] The URL to check
    #
    # @return [String, nil] Returns "active" if the URL is the current page, otherwise nil
    #
    # @example
    #   toolbar_item_class(url: "/home") #=> "active"
    def toolbar_item_class(url:)
      "active" if helpers.current_page?(url)
    end

    # Builds and joins toolbar link list items for the given collection.
    #
    # Each element in *list* is converted to a list item via {#toolbar_link}
    # and then safely joined into an HTML-safe string.
    #
    # @param list [Enumerable] collection of items (e.g. circles, memberships)
    #
    # @return [String] HTML-safe string containing the concatenated toolbar links
    #
    # @example
    #   toolbar_links([circle, membership]) # => "<li>...</li><li>...</li>"
    def toolbar_links(list)
      links = Array(list).map { |item| toolbar_link(item) }
      helpers.safe_join(links)
    end

    # Returns the group if the object is a Socializer::Membership, otherwise returns the object itself
    #
    # @param object [Object] The object to check
    #
    # @return [Object] The group or the object itself
    #
    # @example
    #   toolbar_object(object: membership) #=> group
    #   toolbar_object(object: circle)     #=> circle
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

    # Builds a toolbar list item (li) containing a link for the given item.
    #
    # The method will normalize membership objects to their group via {#toolbar_object},
    # derive the activities path for the item via {#toolbar_link_url}, determine the
    # active CSS class with {#toolbar_item_class}, and wrap the resulting link in an
    # HTML `li` element.
    #
    # @param item [Object] The model to render (e.g. Socializer::Circle or Socializer::Membership)
    #
    # @return [String] an HTML-safe list item string containing the link
    #
    # @example
    #   # Given a decorator instance:
    #   #   decorator.toolbar_link(circle)
    #   #   # => "<li><a href=\"/circles/1/activities\">Circle Name</a></li>"
    def toolbar_link(item)
      item = toolbar_object(object: item)
      url  = toolbar_link_url(item:)
      class_name = toolbar_item_class(url:)

      helpers.tag.li do
        helpers.link_to(item.display_name, url, class: class_name)
      end
    end

    # Builds the path helper name for the given toolbar item and returns the URL.
    #
    # Derives a path helper by demodulizing the class name of `item`, lowercasing
    # it and appending `_activities_path`. Calls the resulting helper with the
    # item's id via `helpers.public_send`.
    #
    # @param item [Object] The model used to build the path (e.g. `Socializer::Circle` or `Socializer::Membership`).
    #
    # @return [String] The generated activities path for the item (e.g. result of `circle_activities_path(item.id)`).
    #
    # @example
    #   toolbar_link_url(item: circle) # => helpers.circle_activities_path(circle.id)
    def toolbar_link_url(item:)
      url_prefix = item.class.name.demodulize.downcase
      helpers.public_send(:"#{url_prefix}_activities_path", item.id)
    end
  end
end
