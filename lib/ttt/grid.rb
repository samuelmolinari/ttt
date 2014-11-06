require_relative '../ttt.rb'

class ::TTT::Grid

  attr_reader :store

  SIZE  = 3
  CELLS = SIZE**2

  def initialize
    @store = Array.new(CELLS)
  end

  def remaining_cell_indexes
    @store.map.with_index do |value,index|
      value.nil? ? index : nil
    end.compact
  end

  def size
    @store.size
  end

end