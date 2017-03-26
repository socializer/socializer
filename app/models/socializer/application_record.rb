# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Base class for ActiveRecord models
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
