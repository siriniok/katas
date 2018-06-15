require 'spec_helper'
require 'game'

describe Game do
  MAX_ROLLS = 20

  let(:game) { subject }

  def roll_many(n, pins)
    n.times do
      game.roll(pins)
    end
  end

  def roll_frame(first_roll, second_roll)
    game.roll(first_roll)
    game.roll(second_roll)
  end

  def roll_spare(first)
    roll_frame(first, described_class::MAX_PINS - first)
  end

  def roll_strike
    game.roll(described_class::MAX_PINS)
  end

  context 'when a player plays all rolls in a gutter' do
    it 'scores 0' do
      pins = 0

      roll_many(MAX_ROLLS, pins)

      expect(game.score).to eq(0)
    end
  end

  context 'when a player knocks down only one pin in all rolls' do
    it 'scores 20' do
      pins = 1

      roll_many(MAX_ROLLS, pins)

      expect(game.score).to eq(20)
    end
  end

  context 'when a player makes a single spare' do
    it 'scores max pins plus the next roll twice' do
      roll_spare(6)
      roll_frame(3, 1)
      roll_many(16, 0)

      expect(game.score).to eq(17)
    end
  end

  context 'when a player makes a single strike' do
    it 'scores max pins plus the next two rolls twice' do
      roll_strike
      roll_frame(3, 1)
      roll_many(16, 0)

      expect(game.score).to eq(18)
    end
  end

  context 'when a player has a perfect game' do
    it 'scores 300' do
      roll_many(12, 10)

      expect(game.score).to eq(300)
    end
  end
end
