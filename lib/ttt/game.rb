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

  # TODO Test
  def start
    puts 'Which player do you want to be? X or O?'
    player = gets.chomp
    parse_player_selection(player)

    # Randomly pick first player
    play([X,O].shuffle.first)

    return
  rescue ArgumentError
    puts 'Invalid, can only be X or O'
    start
  end

  def play(current_player)
    next_player = nil

    if current_player == @computer
      next_player = computer_move
    else
      puts @grid.to_s
      puts "Where do you want to move?"
      cell ||= gets.chomp
      next_player = human_move(cell)
    end

    return won!(current_player) if has_won?(current_player)
    return draw! if @grid.full?

    play(next_player)
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

  # TODO Could be more efficient
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

  def parse_player_selection(selection)
    raise ArgumentError unless selection == X || selection == O
    if selection == X
      @human = X
      @computer = O
    elsif selection == O
      @human = O
      @computer = X
    end
  end

  # TODO Improvate algorithm
  def algorithm
    return @grid.remaining_cell_indexes.shuffle.first
  end

  def winning_array?(player, arr)
    arr.count(player) == ::TTT::Grid::SIZE
  end

end