# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Audience model
  #
  # Every {Socializer::Activity} is shared with one or more
  # {Socializer::Audience audiences}.
  #
  class Audience < ApplicationRecord
    extend Enumerize

    enumerize :privacy, in: %w[public circles limited],
                        default: :public, predicates: true, scope: true

    # Constant for public privacy value
    PUBLIC_PRIVACY = privacy.public.value.freeze
    # Constant for circles privacy value
    CIRCLES_PRIVACY = privacy.circles.value.freeze
    # Constant for limited privacy value
    LIMITED_PRIVACY = privacy.limited.value.freeze

    # Relationships
    belongs_to :activity, inverse_of: :audiences
    belongs_to :activity_object, inverse_of: :audiences, optional: true

    # Validations
    validates :activity_id, presence: false,
                            uniqueness: { scope: :activity_object_id }
    validates :privacy, presence: true

    # Named Scopes

    # Class Methods

    # Grouping for audiences with circle privacy
    #
    # @param viewer_id [Integer] the ID of the viewer
    #
    # @return [Arel::Nodes::Grouping] the grouping condition for circle privacy
    #
    # @example
    #   Socializer::Audience.circle_privacy_grouping(viewer_id: 1)
    def self.circle_privacy_grouping(viewer_id:)
      viewer_literal = viewer_literal(viewer_id:)
      author_ids = ActivityObject.joins(:person).ids
      subquery = Circle.with_author_id(id: author_ids).ids

      arel_table.grouping(arel_table[:privacy].eq(CIRCLES_PRIVACY)
                  .and(viewer_literal.in(subquery)))
    end

    # Grouping for audiences with limited privacy
    #
    # @param viewer_id [Integer] the ID of the viewer
    #
    # @return [Arel::Nodes::Grouping] the grouping condition for limited privacy
    #
    # @example
    #   Socializer::Audience.limited_privacy_grouping(viewer_id: 1)
    def self.limited_privacy_grouping(viewer_id:)
      activity_object_id = arel_table[:activity_object_id]

      arel_table.grouping(arel_table[:privacy].eq(LIMITED_PRIVACY)
                  .and(viewer_literal(viewer_id:).in(limited_circle_subquery)
                    .or(activity_object_id
                          .in(limited_group_subquery(viewer_id)))
                  .or(activity_object_id.in(viewer_id))))
    end

    # Grouping for audiences with public privacy
    #
    # @param viewer_id [Integer] the ID of the viewer
    #
    # @return [Arel::Nodes::Grouping] the grouping condition for public privacy
    #
    # @example
    #   Socializer::Audience.public_privacy_grouping(viewer_id: 1)
    def self.public_privacy_grouping(viewer_id:)
      arel_table.grouping(arel_table[:privacy].eq(PUBLIC_PRIVACY)
                  .or(circle_privacy_grouping(viewer_id:)))
    end

    # Find audiences where the activity_id is equal to the given id
    #
    # @param id [Integer] the ID of the activity
    #
    # @return [ActiveRecord::Relation<Socializer::Audience>]
    #
    # @example
    #   Socializer::Audience.with_activity_id(id: 1)
    def self.with_activity_id(id:)
      where(activity_id: id)
    end

    # Find audiences where the activity_object_id is equal to the given id
    #
    # @param id [Integer] the ID of the activity object
    #
    # @return [ActiveRecord::Relation<Socializer::Audience>]
    #
    # @example
    #   Socializer::Audience.with_activity_object_id(id: 1)
    def self.with_activity_object_id(id:)
      where(activity_object_id: id)
    end

    # Return an Arel SQL literal for the given viewer id so it can be used
    # directly in Arel subqueries.
    #
    # @param viewer_id [Integer, String] the ID of the viewer; converted to String
    #
    # @return [Arel::Nodes::SqlLiteral] SQL literal representing the viewer id
    #
    # @example
    #   Socializer::Audience.viewer_literal(viewer_id: 42)
    #   # => #<Arel::Nodes::SqlLiteral: "42">
    def self.viewer_literal(viewer_id:)
      Arel::Nodes::SqlLiteral.new(viewer_id.to_s)
    end
    private_class_method :viewer_literal

    # Audience : LIMITED
    # Ensure that the audience is LIMITED and then make sure that the viewer
    # is either part of a circle that is the target audience, or that the
    # viewer is part of a group that is the target audience, or that the viewer
    # is the target audience.
    #
    # @return [Array]
    def self.limited_circle_subquery
      # Retrieve the circle's unique identifier related to the audience (when
      # the audience is not a circle, this query will simply return nothing)
      subquery = Circle.joins(activity_object: :audiences).ids
      Tie.with_circle_id(circle_id: subquery).pluck(:contact_id)
    end

    # Limited group subquery
    #
    # @param viewer_id [Integer] the ID of the viewer who wants to see the activity stream
    #
    # @return [Array] the IDs of the activity objects related to the groups the viewer is a member of
    #
    # @example
    #   Socializer::Audience.limited_group_subquery(viewer_id: 1)
    def self.limited_group_subquery(viewer_id)
      ActivityObject.joins(group: :memberships)
                    .merge(Membership.with_member_id(member_id: viewer_id))
                    .ids
    end

    # Instance Methods

    # Returns the activitable object for this audience's activity_object.
    #
    # @return [Object] the activitable associated with the activity_object
    #
    # @example
    #   audience.object # => #<Socializer::Person id: 1, ...>
    def object
      activity_object.activitable
    end
  end
end
