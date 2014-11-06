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

  def has_won?(player)
    return true if winning_array?(player, @grid.first_diagonal) || winning_array?(player, @grid.second_diagonal)
    ::TTT::Grid::SIZE.times.each do |i|
      return true if winning_array?(player, @grid.row(i)) || winning_array?(player, @grid.column(i))
    end
    return false
  end

  def won!(player)
    puts @grid.to_s
    puts "#{player} has won!"
  end

  def draw!
    puts @grid.to_s
    puts "It's a draw!"
  end

  protected

  def algorithm
    return @grid.remaining_cell_indexes.shuffle.first
  end

  def winning_array?(player, arr)
    arr.count(player) == ::TTT::Grid::SIZE
  end

end