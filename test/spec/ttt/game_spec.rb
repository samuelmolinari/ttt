require_relative '../spec_helper'
require 'ttt/game'

describe ::TTT::Game do

  it 'has X' do
    expect(described_class::X).to eq 'X'
  end

  it 'has O' do
    expect(described_class::O).to eq 'O'
  end

  subject(:game) { described_class.new }
  let(:grid) { game.instance_variable_get(:@grid) }

  it { is_expected.to have_attributes(:human => 'X', :computer => 'O') }

  it 'have attribute grid' do
    expect(game.instance_variable_get(:@grid)).to eq ::TTT::Grid.new
  end

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

  describe 'Gameplay' do

    describe '#start' do

      before(:each) do
        game.stub(:play) { |i| nil }
      end

      it 'ask user to choose what player they want to be' do
        count = 0
        game.stub(:gets) { 'O' }
        game.stub(:puts) do |output|
          expect(output).to eq 'Which player do you want to be? X or O?'
        end
        game.start
      end

      context 'with valid input' do
        it 'gives the human player the chosen sign' do
          game.stub(:gets) { 'O' }
          game.start
          expect(game.human).to eq described_class::O
        end
        it 'then picks a player to start the game' do
          game.stub(:gets) { 'O' }
          game.stub(:play) do |player|
            expect([described_class::O, described_class::X]).to include player
          end
          game.start
        end
      end

      context 'with invalid input' do
        it 're-ask if the input is not X or O' do
          step = 0
          game.stub(:gets) do
            if game.human == described_class::O
              expect(step).to be 3
            end

            if step == 0
              value = ''
              step = 1

              game.stub(:puts) do |output|
                expect(output).to eq 'Invalid, can only be X or O'
                game.stub(:puts) {}
              end

            elsif step == 1
              value =  'A'
              step = 2

              game.stub(:puts) do |output|
                expect(output).to eq 'Invalid, can only be X or O'
                game.stub(:puts) {}
              end
            elsif step == 2
              value = described_class::O
              step = 3
            end

            value
          end
          game.start
        end
      end
    end

    describe '#play' do

      before(:each) do
        game.stub(:puts) {}
      end

      context 'using a valid cell' do

        context 'on winning move' do
          let(:winner) { game.computer }
          before(:each) do
            game.stub(:puts) { |output| puts output }
            grid.instance_variable_set(:@store, [winner,winner,nil,'X','X',winner,'X','X',winner])
          end

          it 'ends game returning winner' do 
            expect(game.play(winner)).to eq winner
          end

          it 'outputs the grid and message with winner' do
            stage = 1
            game.stub(:puts) do |output|
              if stage == 1
                expect(output).to eq grid.to_s
                stage = 2
              elsif stage == 2
                expect(output).to eq "#{winner} has won!"
              end
            end
            game.play(winner)
          end
        end

        context 'on draw move' do
          before(:each) do
            game.stub(:puts) { |output| puts output }
            grid.instance_variable_set(:@store, ['O','X',nil,'O','X','X','X','O','O'])
          end

          it 'outputs the grid and message' do
            stage = 1
            game.stub(:puts) do |output|
              if stage == 1
                expect(output).to eq grid.to_s
                stage = 2
              elsif stage == 2
                expect(output).to eq "It's a draw!"
              end
            end
            game.play(game.computer)
          end

          it 'ends game returning nil' do 
            expect(game.play(game.computer)).to be_nil
          end
        end

        context 'with human' do 
          it 'then passes its turn to the computer' do
            game.stub(:gets) do
              input = 'A1'
              game.stub(:play) do |next_player|
                expect(next_player).to eq game.computer
              end      
              input
            end
            game.play(game.human)
          end
        end
        context 'with computer' do
          it 'then passes its turn to the human' do
            play_method = game.method(:play)
            round = 1
            game.stub(:play) do |player|
              if round == 1
                round = 2
                play_method.call player 
              elsif round == 2
                expect(player).to eq game.human
                game.stub(:play) {}
              end
            end

            game.play(game.computer)
          end
        end
      end
      context 'using out of bound cell' do
        it 'warns the user and makes him retry' do
          game.stub(:gets) do
            input = 'D4'

            game.stub(:puts) do |output|
              expect(output).to eq 'This cell does not exists'
              game.stub(:play) do |player|
                expect(player).to eq game.human
              end
            end
            
            input
          end
          game.play(game.human)
        end
      end
      context 'using non-empty cell' do
        let(:cell_code) { 'A1' }
        before(:each) do
          grid.set(cell_code, 'O')
        end
        it 'warns the user and makes him retry' do
          game.stub(:gets) do
            game.stub(:puts) do |output|
              expect(output).to eq 'This cell is not empty'
              game.stub(:play) do |player|
                expect(player).to eq game.human
              end
            end
            
            cell_code
          end
          game.play(game.human)
        end
      end
    end
    context 'with a wrongly formatted cell code' do
      it 'warns the user and makes him retry' do
        step = 0
        game.stub(:gets) do
          input = nil

          game.stub(:puts) do |output|
            expect(output).to eq 'Invalid cell number'
            game.stub(:puts) {}
            game.stub(:play) {} if step == 3
          end
          
          if step == 0
            input = ''
            step = 1
          elsif step == 1
            input = 'A'
            step = 2
          elsif step == 2
            input = '1'
            step = 3
          end

          input
        end
        game.play(game.human)
      end
    end
  end

end