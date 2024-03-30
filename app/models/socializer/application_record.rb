# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # The ApplicationRecord class is an abstract base class that
  # other models in the application inherit from.
  # It is a direct subclass of ActiveRecord::Base.
  #
  # This class is primarily used for defining methods and behaviors
  # that are shared across all models in the application.
  #
  # The `primary_abstract_class` method call indicates that this class
  # is abstract, and therefore, instances of ApplicationRecord should not be
  # created. This method is provided by ActiveRecord.
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
