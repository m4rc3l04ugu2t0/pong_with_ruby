# frozen_string_literal: true

require_relative '../shared/base_stick'

module Player
  # Player
  class Stick < Shared::BaseStick
    def initialize ...
      super(...)

      @initial_position = [
        @margin, (@canvas_height / 2) - (@height / 2)
      ]

      move_to_initial_position
      self.color = 'blue'
    end

    def update_movement(event, speed = nil)
      if y >= 0 && event.key == 'up'
        @y_speed = -(speed || @raw_speed)
      elsif event.key == 'down' && y <= @canvas_height
        @y_speed = speed || @raw_speed
      end
    end
  end
end
