# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  #
  # Module for handling people-related actions
  #
  module People
    #
    # Address controller
    #
    class AddressesController < ApplicationController
      before_action :authenticate_user

      # GET /people/1/addresses/new
      def new
        respond_to do |format|
          format.html { render :new, locals: { address: addresses.new } }
        end
      end

      # GET /people/1/addresses/1/edit
      def edit
        respond_to do |format|
          format.html { render :edit, locals: { address: find_address } }
        end
      end

      # POST /people/1/addresses
      def create
        address = addresses.build(person_address_params)

        if address.save
          flash[:notice] = t("socializer.model.create", model: "Address")
          redirect_to current_user
        else
          render :new
        end
      end

      # PATCH/PUT /people/1/addresses/1
      def update
        address = find_address
        address.update!(person_address_params)

        flash[:notice] = t("socializer.model.update", model: "Address")
        redirect_to current_user
      end

      # DELETE /people/1/addresses/1
      def destroy
        address = find_address
        address.destroy

        flash[:notice] = t("socializer.model.destroy", model: "Address")
        redirect_to current_user
      end

      private

      # Returns the addresses collection associated with the currently authenticated user.
      # The result is memoized to prevent multiple database queries during a single request.
      #
      # @return [ActiveRecord::Relation<Socializer::Address>] the current user's addresses
      #
      # @example
      #   # assume current_user has two addresses
      #   addresses
      #   # => #<ActiveRecord::Relation [#<Socializer::Address id: 1 ...>, #<Socializer::Address id: 2 ...>]>
      def addresses
        return @addresses if defined?(@addresses)

        @addresses = current_user.addresses
      end

      # Finds and memoizes the Address record belonging to the current user matching
      # `params[:id]`.
      #
      # Uses memoization (\@find_address) to prevent repeated database queries during a
      # single request.
      #
      # @return [Socializer::Address, nil] the Address instance when found, otherwise nil
      #
      # @example
      #   # params = { id: '123' }
      #   find_address
      #   # => #<Socializer::Address id: 123, ...> or nil
      def find_address
        return @find_address if defined?(@find_address)

        @find_address = addresses.find_by(id: params[:id])
      end

      # Returns permitted parameters for a person's address extracted from `params`.
      # Uses `params.expect` to require the `:person_address` key and allow expected keys.
      #
      # @return [ActionController::Parameters] the permitted address parameters
      #
      # @example
      #   # params = { person_address: { label: 'Home', line1: '1 Main St' } }
      #   person_address_params
      #   # => #<ActionController::Parameters {"label"=>"Home","line1"=>"1 Main St"} permitted: true>
      def person_address_params
        params.expect(person_address: %i[label line1 line2 city
                                         postal_code_or_zip
                                         province_or_state country])
      end
    end
  end
end
