# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Base class for mail models
  class ApplicationMailer < ActionMailer::Base
    default from: "from@example.com"
    layout "mailer"
  end
end
