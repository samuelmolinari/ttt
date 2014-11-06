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

end