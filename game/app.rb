# frozen_string_literal: true

require_relative '../config/initializers'

class App
  attr_reader :title, :background, :width, :height, :resizable, :color, :size

  @@canvas = Shared::Canvas.new

  def initialize
    @title = 'Ruby pong!!'
    @background = 'black'
    @width = @@canvas.width
    @height = @@canvas.height
    @resizable = false
    @player1_score = Player::Score.new
    @player2_score = Rival::Score.new
    @size = 20
    @color = 'white'
    @game_point = 2
  end

  def self.call = new.call

  def call = run

  private

  def run
    $engine.set(title:, background:, resizable:, width:, height:)

    build_components

    update_game

    $engine.show
  end

  def build_components
    @player1_stick = Player::Stick.new
    @player2_stick = Rival::Stick.new
    @ball = Shared::Ball.new
    print_divisory_line
  end

  def update_game
    $engine.update do
      @player1_stick.update_position
      @player2_stick.update_position
      @ball.update_position

      handle_ball_bounce

      print_texts

      check_end_game
    end

    update_movements
  end

  def update_movements
    $engine.on :key_held do |event|
      @player1_stick.update_movement(event)
      @player2_stick.update_movement(event)
    end

    $engine.on :key_up do |event|
      @player1_stick.update_movement(event, 0)
      @player2_stick.update_movement(event, 0)
    end
  end

  def print_divisory_line
    Rectangle.new(x: @@canvas.width / 2, y: 0, width: 1, height: @@canvas.height, color: 'white')
  end

  def print_texts
    @texts&.each(&:remove)

    @texts = [Text.new("Player1: #{@player1_score.value}",
                       x: @@canvas.margin,
                       y: @@canvas.margin,
                       size:, color:),
              Text.new("player2: #{@player2_score.value}",
                       x: @@canvas.margin,
                       y: @@canvas.margin * 3,
                       size:, color:)]
  end

  def handle_ball_bounce
    handle_next_play
    handle_stick_bounce

    @ball.bounce!([:y]) if @ball.y <= 0
    @ball.bounce!([:y]) if @ball.y >= @@canvas.height - @ball.size
  end

  def handle_next_play
    on_player1_wall = @ball.x <= 0
    on_player2_wall = @ball.x >= @@canvas.width - @ball.size

    return unless on_player1_wall || on_player2_wall

    @ball.move_to_initial_position

    @player2_score.score! if on_player1_wall
    @player1_score.score! if on_player2_wall
  end

  def handle_stick_bounce
    agents = %w[player1 player2]

    agents.each do |agent|
      handle_generic_stick_bounce(agent)
    end
  end

  def handle_generic_stick_bounce(target)
    log_speed

    target_object = instance_variable_get("@#{target}_stick".to_sym)

    return unless send("colides_with_#{target}_stick?")

    direction = [:x]

    speed_factor = if target_object.y_speed.positive? && @ball.y_speed.positive?
                     1.02
                   elsif target_object.y_speed.negative? && @ball.y_speed.negative?
                     1.02
                   else
                     1.01
                   end

    @ball.y_speed *= speed_factor
    @ball.x_speed *= speed_factor

    if target_object.y_speed.negative? && @ball.y_speed.positive?
      direction << :y
    elsif target_object.y_speed.positive? && @ball.y_speed.negative?
      direction << :y
    end

    @ball.bounce!(direction)
  end

  def colides_with_player1_stick?
    if @ball.left <= @player1_stick.right && (@ball.botton >= @player1_stick.top && @ball.top <= @player1_stick.botton)
      return true
    end

    false
  end

  def colides_with_player2_stick?
    if @ball.right >= @player2_stick.left && (@ball.botton >= @player2_stick.top && @ball.top <= @player2_stick.botton)
      return true
    end

    false
  end

  def check_end_game
    if @player1_score.value == @game_point
      $engine.close
      system('figlet Player Wins!')
      system("figlet #{@player1_score.value} x #{@player2_score.value}")
    elsif @player2_score.value == @game_point
      $engine.close
      system('figlet player2 Wins!')
      system("figlet #{@player2_score.value} x #{@player1_score.value}")
    end
  end

  def log_speed
    system 'clear'
    puts({ ball_y_speed: @ball.y_speed, ball_x_speed: @ball.x_speed })
  end
end

App.call
