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

    # Format the birthdate attribute
    #
    # @return [String]
    def birthday
      model.birthdate? ? model.birthdate.to_s(:long_ordinal) : nil
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
      item       = item.group if item.class.name == 'Socializer::Membership'
      provider   = item.class.name.demodulize.tableize.to_sym
      item_id    = item.id
      item_name  = item.name
      class_name = 'active' if helpers.current_page?(helpers.stream_path(provider: provider, id: item_id))

      helpers.content_tag(:li) do
        helpers.link_to(item_name, helpers.stream_path(provider: provider, id: item_id), class: class_name)
      end
    end
  end
end
