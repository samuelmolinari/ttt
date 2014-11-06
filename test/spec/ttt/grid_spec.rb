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

end