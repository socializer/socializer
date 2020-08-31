# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActiveSupport::Inflector do
  describe "singularize" do
    describe "returns the singular form of a word" do
      specify { expect("ties".singularize(:en)).to eq("tie") }
      specify { expect("Ties".singularize(:en)).to eq("Tie") }
      specify { expect("activities".singularize(:en)).to eq("activity") }
      specify { expect("Activities".singularize(:en)).to eq("Activity") }
    end

    describe "do not alter an already singular word" do
      specify { expect("tie".singularize(:en)).to eq("tie") }
      specify { expect("Tie".singularize(:en)).to eq("Tie") }
      specify { expect("activity".singularize(:en)).to eq("activity") }
      specify { expect("Activity".singularize(:en)).to eq("Activity") }
    end
  end
end
