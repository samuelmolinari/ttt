require_relative '../ttt.rb'

class ::TTT::Grid

  attr_reader :store

  SIZE  = 3
  CELLS = SIZE**2

  FIRST_COLUMN_LETTER = 'a'
  FIRST_ROW_NUMBER = 1

  def initialize
    @store = Array.new(CELLS)
  end

  def set(cell_code, value)
    index = cell_index(cell_code)
    return set_at(index, value)
  end

  def set_at(index, value)
    raise IndexError if index >= size
    raise ::TTT::Grid::GridIsFull if full?
    raise ::TTT::Grid::CellIsNotEmpty unless empty_cell?(index)

    @store[index] = value

    return self
  end

  def row(n)
    SIZE.times.map do |i|
      cell_index = (SIZE * n) + i
      @store[cell_index]
    end
  end

  def column(n)
    SIZE.times.map do |i|
      cell_index = (SIZE * i) + n
      @store[cell_index]
    end
  end

  def first_diagonal
    SIZE.times.map do |n|
      cell_index = (SIZE * n) + n
      @store[cell_index]
    end
  end

  def second_diagonal
    SIZE.times.map do |n|
      cell_index = (SIZE * n) + (SIZE - (n + 1))
      @store[cell_index]
    end
  end

  def full?
    remaining_cell_indexes.size == 0
  end

  def empty_cell?(index)
    @store[index].nil?
  end

  def remaining_cell_indexes
    @store.map.with_index do |value,index|
      value.nil? ? index : nil
    end.compact
  end

  def size
    @store.size
  end

  def ==(other)
    other.store == self.store
  end

  protected

  def cell_index(cell_code)
    cell = convert_cell_code(cell_code)
    return cell_index_at(cell[:row],cell[:column])
  end

  def cell_index_at(row,column)
    return (row * SIZE) + column
  end

  def convert_cell_code(cell_code)
    cell_code = cell_code.downcase
    
    # Get the letter, get its code and reduce it to match its index
    column = cell_code.scan(/[a-z]/)[0].ord - FIRST_COLUMN_LETTER[0].ord
    # Get the number, convert it to integer and reduce it to match its index
    row = cell_code.scan(/[0-9]/)[0].to_i - FIRST_ROW_NUMBER
    
    return {
      :row => row,
      :column => column
    }
  end

end

class ::TTT::Grid::GridIsFull < Exception
end

class ::TTT::Grid::CellIsNotEmpty < Exception
end