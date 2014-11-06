require 'ttt/game'

describe ::TTT::Game do

  it 'has X' do
    expect(described_class::X).to eq 'X'
  end

  it 'has O' do
    expect(described_class::O).to eq 'O'
  end

  subject(:game) { described_class.new }

  it { is_expected.to have_attributes(:grid => ::TTT::Grid.new, :human => 'X', :computer => 'O') }

end