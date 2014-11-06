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
    return @human
  end

  def human_move(cell_code)
    next_player = @computer

    begin
      @grid.set(cell_code, @human)
    rescue IndexError
      puts "This cell does not exists"
      next_player = @human
    rescue ::TTT::Grid::CellIsNotEmpty
      puts "This cell is not empty"
      next_player = @human
    rescue Exception
      puts "Invalid cell number"
      next_player = @human
    end

    return next_player
  end

  protected

  def algorithm
    return @grid.remaining_cell_indexes.shuffle.first
  end

end