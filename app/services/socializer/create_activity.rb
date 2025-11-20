# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Service object for creating a Socializer::Activity
  #
  class CreateActivity
    include ActiveModel::Model
    include Utilities::Message

    # @!attribute [rw] actor_id
    #   @return [Integer] the ID of the actor
    # @!attribute [rw] activity_object_id
    #   @return [Integer] the ID of the activity object
    # @!attribute [rw] target_id
    #   @return [Integer, nil] the ID of the target, if any
    # @!attribute [rw] verb
    #   @return [String] the verb describing the activity
    # @!attribute [rw] object_ids
    #   @return [String, Array<Integer>] the IDs of the objects involved in the activity
    # @!attribute [rw] content
    #   @return [String, nil] the content of the activity, if any
    attr_accessor :actor_id, :activity_object_id, :target_id, :verb,
                  :object_ids, :content

    # Validations
    validates :actor_id, presence: true
    validates :activity_object_id, presence: true
    validates :verb, presence: true

    # Instance Methods

    # Invoke the CreateActivity. This is the primary public API method.
    # Creates an activity, adds the content and audience if needed.
    #
    # @return [Array, Socializer::Activity]
    def call
      create_activity
    end

    private

    # Builds an ActivityField for the activity when `content` is present.
    #
    # @return [ActivityField, nil] an instance of ActivityField containing the
    #   provided content, or `nil` when `content` is blank.
    #
    # @example
    #   # inside an instance of `Socializer::CreateActivity`
    #   self.content = "Hello world"
    #   activity_field # => ActivityField.new(content: "Hello world")
    def activity_field
      ActivityField.new(content:) if content.present?
    end

    # Builds a Hash of attributes for creating a `Socializer::Activity`.
    #
    # The returned hash contains:
    # - `:actor_id` — the ID of the actor performing the activity
    # - `:activity_object_id` — the ID of the primary object for the activity
    # - `:target_id` — optional target ID (may be `nil`)
    # - `:verb` — a `Verb` record resolved by `display_name` (created if missing)
    #
    # @return [Hash] attributes suitable for `Activity.create`
    #
    # @example
    #   # inside an instance of Socializer::CreateActivity
    #   self.actor_id = 1
    #   self.activity_object_id = 2
    #   self.target_id = nil
    #   self.verb = 'post'
    #   Activity.create(activity_attributes)
    def activity_attributes
      {
        actor_id:,
        activity_object_id:,
        target_id:,
        verb: Verb.find_or_create_by(display_name: verb)
      }
    end

    # Adds audience entries to the provided activity based on `object_ids`.
    # Iterates over `object_ids_array`, determines the correct privacy for each
    # audience id and builds an Audience on the activity. When the privacy is the
    # configured limited value, the audience's `activity_object_id` is set to the
    # original audience id.
    #
    # @param activity [Socializer::Activity] the activity to which audiences will be added
    #
    # @return [void]
    #
    # @example
    #   # inside an instance of Socializer::CreateActivity
    #   self.object_ids = "1,2,3"
    #   activity = Activity.new
    #   add_audience_to_activity(activity: activity)
    #   activity.audiences.size # => 3
    def add_audience_to_activity(activity:)
      object_ids_array.each do |audience_id|
        privacy  = audience_privacy(audience_id:)
        audience = activity.audiences.build(privacy:)

        audience.activity_object_id = audience_id if privacy == limited_privacy
      end
    end

    # Converts the `object_ids` attribute into an Array.
    # If `object_ids` is a comma-separated `String`, returns the result of `split(",")`.
    # Otherwise assumes `object_ids` is already an `Array` and returns it unchanged.
    #
    # @return [Array<Integer, String>, String] an array of object id values
    #
    # @example
    #   self.object_ids = "1,2,3"
    #   object_ids_array # => ["1", "2", "3"]
    #
    #   self.object_ids = [1, 2, 3]
    #   object_ids_array # => [1, 2, 3]
    def object_ids_array
      return object_ids.split(",") if Set.new(%w[Integer String]).include?(object_ids.class.name)

      object_ids
    end

    # Returns the appropriate privacy value for the given `audience_id`.
    #
    # Checks whether the provided `audience_id` represents a non\-limited audience
    # (public or circles). If it does, the method returns that identifier; otherwise
    # it returns the configured limited privacy value. The result is memoized in
    # `@audience_privacy` to avoid repeated computation.
    #
    # @param audience_id [Object, String, Integer] The audience identifier to evaluate (commonly Integer or String)
    #
    # @return [Object] The privacy value to use for the activity's audience
    #
    # @example
    #   # inside an instance of Socializer::CreateActivity
    #   audience_privacy(audience_id: Audience.privacy.public.value)
    #   # => Audience.privacy.public.value
    def audience_privacy(audience_id:)
      return @audience_privacy if defined?(@audience_privacy)

      not_limited = Set.new(%W[#{public_privacy} #{circles_privacy}])

      @audience_privacy = if not_limited.include?(audience_id)
                            audience_id
                          else
                            limited_privacy
                          end
    end

    # Returns the memoized value used to represent `circles` audience privacy.
    #
    # This method fetches `Audience.privacy.circles.value` and caches it in
    # `@circles_privacy` to avoid repeated lookups.
    #
    # @return [Object] the privacy value (commonly an Integer or String)
    #
    # @example
    #   # inside an instance of Socializer::CreateActivity
    #   circles_privacy #=> Audience.privacy.circles.value
    def circles_privacy
      return @circles_privacy if defined?(@circles_privacy)

      @circles_privacy = Audience.privacy.circles.value
    end

    # Returns the memoized value used to represent `limited` audience privacy.
    #
    # This method fetches `Audience.privacy.limited.value` and caches it in
    # `@limited_privacy` to avoid repeated lookups.
    #
    # @return [Object] the privacy value (commonly an Integer or String)
    #
    # @example
    #   # inside an instance of Socializer::CreateActivity
    #   limited_privacy #=> Audience.privacy.limited.value
    def limited_privacy
      return @limited_privacy if defined?(@limited_privacy)

      @limited_privacy = Audience.privacy.limited.value
    end

    # Returns the memoized value used to represent `public` audience privacy.
    #
    # This method fetches `Audience.privacy.public.value` and caches it in
    # `@public_privacy` to avoid repeated lookups.
    #
    # @return [Object] the privacy value (commonly an Integer or String)
    #
    # @example
    #   # inside an instance of Socializer::CreateActivity
    #   public_privacy #=> Audience.privacy.public.value
    def public_privacy
      return @public_privacy if defined?(@public_privacy)

      @public_privacy = Audience.privacy.public.value
    end

    # Creates and persists a `Socializer::Activity`.
    #
    # The activity is initialized with the `activity_attributes`, the
    # `activity_field` is assigned when `content` is present, and any audiences
    # defined by `object_ids` are added to the activity.
    #
    # @return [Array, Socializer::Activity] the newly created activity
    #
    # @example
    #   # inside an instance of `Socializer::CreateActivity`
    #   # given `actor_id`, `activity_object_id`, and `verb` are set
    #   create_activity #=> #<Socializer::Activity ...>
    def create_activity
      Activity.create(activity_attributes) do |activity|
        activity.activity_field = activity_field

        add_audience_to_activity(activity:) if object_ids.present?
      end
    end
  end
end
