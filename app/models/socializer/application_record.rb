# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Base class for ActiveRecord models
  class ApplicationRecord < ActiveRecord::Base
    primary_abstract_class
  end
end
