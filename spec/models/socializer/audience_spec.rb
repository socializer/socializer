require 'spec_helper'

module Socializer
  describe Audience do
    pending "add additional examples to #{__FILE__}"

    it { should enumerize(:privacy_level).in(:public, :circles, :limited).with_default(:public) }
  end
end
