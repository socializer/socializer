# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActiveSupport::Inflector do
  context "singularize" do
    context "returns the singular form of a word" do
      it { expect("ties".singularize(:en)).to eq("tie") }
      it { expect("Ties".singularize(:en)).to eq("Tie") }
      it { expect("activities".singularize(:en)).to eq("activity") }
      it { expect("Activities".singularize(:en)).to eq("Activity") }
    end

    context "do not alter an already singular word" do
      it { expect("tie".singularize(:en)).to eq("tie") }
      it { expect("Tie".singularize(:en)).to eq("Tie") }
      it { expect("activity".singularize(:en)).to eq("activity") }
      it { expect("Activity".singularize(:en)).to eq("Activity") }
    end
  end
end
