# frozen_string_literal: true

module Shared
  # Draw canvas
  class Canvas
    attr_reader :height, :width, :margin

    def initialize
      @width = 400
      @height = 400
      @margin = 10
    end
  end
end
