require_relative '../spec_helper'
require 'ttt/grid'

describe ::TTT::Grid do

  it 'has a size of 3 by 3' do
    expect(described_class::SIZE).to be 3
  end

  it 'has 9 cells' do
    expect(described_class::CELLS).to be 9
  end

  subject(:grid) { described_class.new }

  it { is_expected.to have_attributes(:store => Array.new(described_class::CELLS)) }

  describe '#size' do
    it 'returns the number of cells' do
      expect(grid.size).to be described_class::CELLS
    end
  end

  describe '#set' do
    it 'returns self' do
      expect(grid.set('A1', true)).to be grid
    end

    context 'when cell is valid' do
      let!(:valid_cell_1) { ({ code: 'A1', index: 0, value: 'Hi!' }) }
      let!(:valid_cell_2) { ({ code: 'B2', index: 4, value: 'Futurelearn' }) }
      let!(:valid_cell_3) { ({ code: 'C3', index: 8, value: '!' }) }

      it 'stores value in the right cells' do
        [valid_cell_1, valid_cell_2, valid_cell_3].each do |cell|
          expect(grid.set(cell[:code], cell[:value]).store[cell[:index]]).to eq cell[:value]
        end
      end
    end

    context 'when grid is full' do
      before(:each) do
        grid.instance_variable_set(:@store, Array.new(described_class::CELLS, true))
      end

      it 'raises a GridIsFull exception' do
        expect { grid.set('A1', true) }.to raise_exception ::TTT::Grid::GridIsFull 
      end
    end

    context 'when cell is not empty' do
      let(:cell_code) { 'A1' }
      before(:each) do
        grid.set(cell_code, true)
      end

      it 'raises a CellIsNotEmpty exception' do
        expect { grid.set(cell_code, true) }.to raise_exception ::TTT::Grid::CellIsNotEmpty
      end
    end

    context 'when cell is out of bounds' do
      let(:cell_out_of_bound) { 'D4' }

      it 'raises a IndexError exception' do
        expect { grid.set(cell_out_of_bound, true) }.to raise_exception IndexError
      end
    end
  end

  describe '#empty_cell?' do
    let(:cell_index) { 1 }
    context 'when cell is empty' do
      it 'returns true' do
        expect(grid.empty_cell?(cell_index)).to be true
      end
    end
    context 'when cell is set' do
      before(:each) do
        grid.store[cell_index] = false
      end
      it 'returns false' do
        expect(grid.empty_cell?(cell_index)).to be false
      end
    end
  end

  describe '#full?' do
    context 'grid is full' do

      before(:each) do
        grid.instance_variable_set(:@store, Array.new(described_class::CELLS, true))
      end

      it 'returns true' do
        expect(grid).to be_full
      end
    end
    context 'grid is not full' do
      before(:each) do
        grid.instance_variable_set(:@store, [1,2,3,4,5,6,nil,nil,nil])
      end

      it 'returns false' do
        expect(grid).not_to be_full
      end
    end
  end

  describe '#remaining_cell_indexes' do
    before(:each) do
      grid.instance_variable_set(:@store, [1,2,3,4,5,6,nil,nil,nil])
    end

    it 'returns array of index of cells that are empty' do
      expect(grid.remaining_cell_indexes).to eq [6,7,8]
    end
  end

  describe '#row' do
    before(:each) do
      grid.instance_variable_set(:@store, [1,2,3,4,nil,6,nil,8,nil])
    end

    it 'returns the given row as an array' do
      expect(grid.row(0)).to eq [1,2,3]
      expect(grid.row(1)).to eq [4,nil,6]
      expect(grid.row(2)).to eq [nil,8,nil]
    end
  end

  describe '#column' do
    before(:each) do
      grid.instance_variable_set(:@store, [1,2,3,4,nil,6,nil,8,nil])
    end

    it 'returns the given row as an array' do
      expect(grid.column(0)).to eq [1,4,nil]
      expect(grid.column(1)).to eq [2,nil,8]
      expect(grid.column(2)).to eq [3,6,nil]
    end
  end

  describe '#first_diagonal' do
    before(:each) do
      grid.instance_variable_set(:@store, [1,nil,nil,nil,5,6,nil,8,9])
    end

    it 'returns the diagonal starting from the top left to the bottom right' do
      expect(grid.first_diagonal).to eq [1,5,9]
    end
  end

  describe '#second_diagonal' do
    before(:each) do
      grid.instance_variable_set(:@store, [1,nil,3,nil,5,6,7,8,9])
    end

    it 'returns the diagonal starting from the top right to the bottom left' do
      expect(grid.second_diagonal).to eq [3,5,7]
    end
  end

end