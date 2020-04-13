# frozen_string_literal: true

module Socializer
  #
  # Application mailer
  #
  class ApplicationMailer < ActionMailer::Base
    default from: "from@example.com"
    layout "mailer"
  end
end
