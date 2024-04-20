# frozen_string_literal: true

module Shared
  # Score players
  class BaseScore
    attr_reader :value

    def initialize
      @value = 0
    end

    def score!
      @value += 1
    end
  end
end
