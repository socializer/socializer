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

    def birthday
      model.birthdate? ? model.birthdate.to_s(:long_ordinal) : nil
    end

    def toolbar_stream_links
      list = model.circles + model.memberships
      return if list.blank?

      html = []

      list[0..2].map do |item|
        html << toolbar_link(item)
      end.join.html_safe

      html << helpers.content_tag(:li, class: 'dropdown') do
        dropdown_link +

        helpers.content_tag(:ul, class: 'dropdown-menu') do
          list[3..(list.size)].map do |item|
            toolbar_link(item)
          end.join.html_safe
        end
      end

      html.join.html_safe
    end

    private

    def dropdown_link
      icon = helpers.content_tag(:span, nil, class: 'fa fa-angle-down fa-fw')
      helpers.link_to('#', class: 'dropdown-toggle', data: { toggle: 'dropdown' }) do
        # TODO: should be able to use relative keys. Doesn't work in test
        "#{helpers.t('socializer.shared.toolbar.more')} #{icon}".html_safe
      end
    end

    def toolbar_link(item)
      if item.class.name == 'Socializer::Circle'
        provider = :circles
        item_id  = item.id
        item_name = item.name
      end

      if item.class.name == 'Socializer::Membership'
        provider  = :groups
        item_id   = item.group.id
        item_name = item.group.name
      end

      class_name = 'active' if helpers.current_page?(helpers.stream_path(provider: provider, id: item_id))

      helpers.content_tag(:li) do
        helpers.link_to(item_name, helpers.stream_path(provider: provider, id: item_id), class: class_name)
      end
    end
  end
end
