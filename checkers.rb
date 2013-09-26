module Checkers

  class Game
    def initialize
      board = Checkers::Board.new
    end

    def play
      start_pos, end_pos = get_input
      input
    end

    private

    def get_input
      puts "From:"
      start_pos = gets.chomp.gsub('/[^12345678]', "").split(",")
      puts "To:"
      start_pos = gets.chomp.gsub('/[^12345678]', "").split(",")
      [start_pos, end_pos]
    end

  end
end

game = Game.new
game.play