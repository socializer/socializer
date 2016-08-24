# frozen_string_literal: true
#
# Namespace for the Socializer engine
#
module Socializer
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
