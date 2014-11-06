require 'ttt/game'

describe ::TTT::Game do

  it 'has X' do
    expect(described_class::X).to eq 'X'
  end

  it 'has O' do
    expect(described_class::O).to eq 'O'
  end

  subject(:game) { described_class.new }
  let(:grid) { game.grid }

  it { is_expected.to have_attributes(:grid => ::TTT::Grid.new, :human => 'X', :computer => 'O') }

  describe 'computer_move' do

    before(:each) do
      grid.instance_variable_set(:@store, [1,2,3,nil,5,6,7,8,9])
    end

    it 'only moves in available cells' do
      game.computer_move
      expect(grid.empty_cell?(3)).to be false
    end

    xit 'makes sure it does it for any case time'
  end

end