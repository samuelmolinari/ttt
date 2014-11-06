require_relative '../ttt.rb'
require_relative './grid.rb'

class ::TTT::Game

  attr_reader :human, :computer, :grid

  X = 'X'
  O = 'O'

  def initialize
    @human    = X
    @computer = O
    @grid = ::TTT::Grid.new
  end

end