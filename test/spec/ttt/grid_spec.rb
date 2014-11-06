require 'ttt/grid'

describe ::TTT::Grid do

  it 'has a size of 3 by 3' do
    expect(described_class::SIZE).to be 3
  end

  it 'has 9 cells' do
    expect(described_class::CELLS).to be 9
  end

end