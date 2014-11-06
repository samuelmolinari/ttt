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

    it 'stores computer value to cell' do
      game.computer_move
      expect(grid.store[3]).to eq game.computer
    end

    it 'returns human as next player' do
      expect(game.computer_move).to eq game.human
    end

    xit 'makes sure it does it for any case time'
  end

  describe 'human_move' do
    context 'when cell code is valid' do
      before(:each) do
        game.human_move('A1')
      end
      it 'returns computer as the next player' do
        expect(game.human_move('A3')).to eq game.computer
      end
      it 'stores human value to cell' do
        expect(grid.store[0]).to eq game.human
      end
    end
    context 'when cell code is invalid' do
      it 'returns human as next player' do
        expect(game.human_move('a')).to eq game.human
        expect(game.human_move(nil)).to eq game.human
      end
    end
    context 'when given cell is out of bound' do
      it 'returns human as next player' do
        expect(game.human_move('D4')).to eq game.human
      end
    end
    context 'when given cell is not empty' do
      let(:cell_code) { 'A1' }
      before(:each) do
        game.human_move(cell_code)
      end
      it 'returns human as next player' do
        expect(game.human_move(cell_code)).to eq game.human
      end
    end
  end

  describe '#has_won?' do
    let(:winner) { game.human }

    context 'with winning row' do
      before(:each) do
        grid.instance_variable_set(:@store, [winner, winner, winner,nil,nil,nil,nil,nil,nil])
      end
      it 'returns true' do
        expect(game.has_won?(winner)).to be true
      end
    end

    context 'with winning column' do
      before(:each) do
        grid.instance_variable_set(:@store, [winner,nil,nil,winner,nil,nil,winner,nil,nil])
      end
      it 'returns true' do
        expect(game.has_won?(winner)).to be true
      end
    end

    context 'with winning first diagonal' do
      before(:each) do
        grid.instance_variable_set(:@store, [winner,nil,nil,nil,winner,nil,nil,nil,winner])
      end
      it 'returns true' do
        expect(game.has_won?(winner)).to be true
      end
    end

    context 'with winning second diagonal' do
      before(:each) do
        grid.instance_variable_set(:@store, [nil,nil,winner,nil,winner,nil,winner,nil,nil])
      end
      it 'returns true' do
        expect(game.has_won?(winner)).to be true
      end
    end
    
    context 'with no winning set' do
      it 'returns false' do
        expect(game.has_won?(winner)).to be false
      end
    end
  end

end