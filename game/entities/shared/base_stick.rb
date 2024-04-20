# frozen_string_literal: true

module Shared
  # Base Stick Draw
  class BaseStick < Rectangle
    attr_accessor :y_speed

    def initialize ...
      super(...)
      @initial_position = [0, 0]
      @width = 10
      @height = 100

      fetch_canvas_attributes

      @y_speed = 0
      @raw_speed = 3
    end

    def update_position
      self.y += y_speed if going_up? || going_down?
    end

    def move_to_initial_position
      self.x, self.y = @initial_position
    end

    def top
      self.y
    end

    def right
      x + width
    end

    def botton
      self.y + height
    end

    def left
      x
    end

    private

    def going_up?
      y_speed.negative? && y >= 0
    end

    def going_down?
      y_speed.positive? && y <= (@canvas_height - @height)
    end

    def fetch_canvas_attributes
      @canvas_width = App.class_variable_get(:@@canvas).width
      @canvas_height = App.class_variable_get(:@@canvas).height
      @margin = App.class_variable_get(:@@canvas).margin
    end
  end
end
