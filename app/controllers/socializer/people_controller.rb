# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # People controller
  class PeopleController < ApplicationController
    before_action :authenticate_user

    # GET /people
    def index
      @people = Person.all.decorate
    end

    # GET /people/1
    def show
      @person = find_person
    end

    # GET /people/1/edit
    def edit
      @person = current_user
    end

    # PATCH/PUT /people/1
    def update
      current_user.update!(person_params)

      flash[:notice] = t("socializer.model.update", model: "Person")
      redirect_to current_user
    end

    private

    # Finds and returns the requested Person decorated for view use.
    # Looks up the Person by `params[:id]` and decorates the result.
    # Returns `nil` when no matching record is found.
    #
    # @return [Socializer::PersonDecorator, nil] decorated Person or nil
    #
    # @example
    #   # GET /people/1
    #   @person = find_person
    #   # => #<Socializer::PersonDecorator:0x000...>
    def find_person
      Person.find_by(id: params[:id]).decorate
    end

    # Returns the permitted parameters for a Person update request.
    # Uses the controller `params` hash and expects a top-level `:person` key.
    #
    # @return [ActionController::Parameters] the filtered parameters for `:person`
    #
    # @example
    #   # Given params:
    #   # { person: { display_name: "Alice", email: "a@example.com" } }
    #   #
    #   # Calling:
    #   person_params
    #   # => ActionController::Parameters with only the permitted person attributes
    def person_params
      params.expect(person: %i[display_name email language avatar_provider
                               tagline introduction bragging_rights occupation
                               skills gender looking_for_friends
                               looking_for_dating looking_for_relationship
                               looking_for_networking birthdate relationship
                               other_names])
    end
  end
end
