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

  def computer_move
    index = algorithm
    @grid.set_at(index, @computer)
  end

  protected

  def algorithm
    return @grid.remaining_cell_indexes.shuffle.first
  end

end